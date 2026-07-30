//
//  CaloriesTrackingLocalDataSource.swift
//  NutriScan
//
//  Created by albaraa alsayed on 16/02/1448 AH.
//

import Foundation
import Observation

struct CaloriesActivityDraft: Codable, Equatable, Identifiable {
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
final class CaloriesActivityStore {
    private(set) var drafts: [String: CaloriesActivityDraft]

    private let defaults: UserDefaults
    private let storageKey = "nutriscan.daily-activity-drafts.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([String: CaloriesActivityDraft].self, from: data) {
            drafts = decoded
        } else {
            drafts = [:]
        }
    }

    func draft(profileID: String, date: String) -> CaloriesActivityDraft? {
        drafts[key(profileID: profileID, date: date)]
    }

    @discardableResult
    func seedIfNeeded(profileID: String, tracking: CaloriesTracking) -> CaloriesActivityDraft {
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

        let draft = CaloriesActivityDraft(
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
        var draft = drafts[draftKey] ?? CaloriesActivityDraft(
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
        var draft = drafts[draftKey] ?? CaloriesActivityDraft(
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

    func pendingDrafts(profileID: String, before date: String) -> [CaloriesActivityDraft] {
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
