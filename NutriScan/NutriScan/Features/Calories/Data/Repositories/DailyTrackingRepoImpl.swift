//
//  DailyTrackingRepoImpl.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation
import Observation

struct DailyActivityDraft: Codable, Equatable, Identifiable {
    let profileID: String
    let date: String
    var stepsCnt: Int
    var stepsKcal: Int
    var exerciseKcal: Int
    var exerciseSeconds: Double
    var totalMealKcal: Int
    var isSeededFromServer: Bool

    var id: String { "\(profileID)|\(date)" }

    var exerciseMin: Double {
        ((exerciseSeconds / 60) * 10).rounded() / 10
    }
}

@MainActor
@Observable
final class DailyActivityStore {
    private(set) var drafts: [String: DailyActivityDraft]

    private let defaults: UserDefaults
    private let storageKey = "nutriscan.daily-activity-drafts.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([String: DailyActivityDraft].self, from: data) {
            drafts = decoded
        } else {
            drafts = [:]
        }
    }

    func draft(profileID: String, date: String) -> DailyActivityDraft? {
        drafts[key(profileID: profileID, date: date)]
    }

    @discardableResult
    func seedIfNeeded(profileID: String, tracking: DailyTracking) -> DailyActivityDraft {
        let draftKey = key(profileID: profileID, date: tracking.date)
        if var existing = drafts[draftKey] {
            guard !existing.isSeededFromServer else { return existing }
            existing.stepsCnt = max(existing.stepsCnt, tracking.stepsCnt)
            existing.stepsKcal = max(existing.stepsKcal, tracking.stepsKcal)
            existing.exerciseKcal += tracking.exerciseKcal
            existing.exerciseSeconds += tracking.exerciseMin * 60
            existing.totalMealKcal = tracking.totalCalories
            existing.isSeededFromServer = true
            drafts[draftKey] = existing
            persist()
            return existing
        }

        let draft = DailyActivityDraft(
            profileID: profileID,
            date: tracking.date,
            stepsCnt: tracking.stepsCnt,
            stepsKcal: tracking.stepsKcal,
            exerciseKcal: tracking.exerciseKcal,
            exerciseSeconds: tracking.exerciseMin * 60,
            totalMealKcal: tracking.totalCalories,
            isSeededFromServer: true
        )
        drafts[draftKey] = draft
        persist()
        return draft
    }

    func updateSteps(profileID: String, date: String, steps: Int, calories: Int) {
        let draftKey = key(profileID: profileID, date: date)
        var draft = drafts[draftKey] ?? DailyActivityDraft(
            profileID: profileID,
            date: date,
            stepsCnt: 0,
            stepsKcal: 0,
            exerciseKcal: 0,
            exerciseSeconds: 0,
            totalMealKcal: 0,
            isSeededFromServer: false
        )
        draft.stepsCnt = max(steps, 0)
        draft.stepsKcal = max(calories, 0)
        drafts[draftKey] = draft
        persist()
    }

    func updateMealCalories(profileID: String, date: String, calories: Int) {
        let draftKey = key(profileID: profileID, date: date)
        guard var draft = drafts[draftKey] else { return }
        draft.totalMealKcal = max(calories, 0)
        drafts[draftKey] = draft
        persist()
    }

    func recordWorkout(profileID: String, date: String, calories: Int, elapsedSeconds: Int) {
        let draftKey = key(profileID: profileID, date: date)
        var draft = drafts[draftKey] ?? DailyActivityDraft(
            profileID: profileID,
            date: date,
            stepsCnt: 0,
            stepsKcal: 0,
            exerciseKcal: 0,
            exerciseSeconds: 0,
            totalMealKcal: 0,
            isSeededFromServer: false
        )
        draft.exerciseKcal += max(calories, 0)
        draft.exerciseSeconds += Double(max(elapsedSeconds, 0))
        drafts[draftKey] = draft
        persist()
    }

    func pendingDrafts(profileID: String, before date: String) -> [DailyActivityDraft] {
        drafts.values
            .filter { $0.profileID == profileID && $0.date < date }
            .sorted { $0.date < $1.date }
    }

    func remove(profileID: String, date: String) {
        drafts.removeValue(forKey: key(profileID: profileID, date: date))
        persist()
    }

    private func key(profileID: String, date: String) -> String {
        "\(profileID)|\(date)"
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(drafts) else { return }
        defaults.set(data, forKey: storageKey)
    }
}

final class DailyTrackingRepoImpl: DailyTrackingRepo {

    private let service: DailyTrackingService

    init(service: DailyTrackingService) {
        self.service = service
    }

    func getTodayTracking() async throws -> DailyTracking {
        DailyTracking(from: try await service.fetchToday())
    }

    func getTrackingByDate(date: String) async throws -> DailyTracking {
        DailyTracking(from: try await service.fetchByDate(date: date))
    }

    func getAllTracking(page: Int, size: Int) async throws -> (items: [DailyTrackingSummary], totalPages: Int) {
        let page = try await service.fetchAll(page: page, size: size)
        let items = page.content.map { DailyTrackingSummary(from: $0) }
        return (items, page.totalPages)
    }

    func addMeal(date: String, scanId: String, mealCnt: Int) async throws -> Meal {
        let request = AddMealRequestDTO(scanId: scanId, mealCnt: mealCnt)
        let result = try await service.addMeal(date: date, request: request)
        return Meal(from: result)
    }

    func updateMealCount(date: String, scanId: String, mealCnt: Int) async throws -> Meal {
        let request = UpdateMealCountRequestDTO(mealCnt: mealCnt)
        let result = try await service.updateMeal(date: date, scanId: scanId, request: request)
        return Meal(from: result)
    }

    func deleteMeal(date: String, scanId: String) async throws {
        try await service.deleteMeal(date: date, scanId: scanId)
    }

    func updateTracking(
        date: String,
        targetWaterCnt: Int?,
        waterCnt: Int?,
        stepsCnt: Int?,
        stepsKcal: Int?,
        exerciseKcal: Int?,
        exerciseMin: Double?,
        totalMealKcal: Int?
    ) async throws -> DailyTracking {
        let body = PatchDailyTrackingDTO(
            date: date,
            targetWaterCnt: targetWaterCnt,
            waterCnt: waterCnt,
            stepsCnt: stepsCnt,
            stepsKcal: stepsKcal,
            exerciseKcal: exerciseKcal,
            exerciseMin: exerciseMin,
            totalMealKcal: totalMealKcal
        )
        return DailyTracking(from: try await service.patchTracking(date: date, body: body))
    }

    func deleteTracking(date: String) async throws {
        try await service.deleteTracking(date: date)
    }
}
