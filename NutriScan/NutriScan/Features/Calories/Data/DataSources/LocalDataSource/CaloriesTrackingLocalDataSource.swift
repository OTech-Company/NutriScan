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
    var stepsKcal: Double
    var exerciseKcal: Double
    var exerciseSeconds: Double
    var totalMealKcal: Int
    var isSeededFromServer: Bool
    var needsStepSync: Bool
    var needsExerciseSync: Bool

    var id: String { "\(profileID)|\(date)" }

    var exerciseMin: Double {
        ((exerciseSeconds / 60) * 10).rounded() / 10
    }

    init(
        profileID: String,
        date: String,
        stepsCnt: Int,
        stepsKcal: Double,
        exerciseKcal: Double,
        exerciseSeconds: Double,
        totalMealKcal: Int,
        isSeededFromServer: Bool,
        needsStepSync: Bool = false,
        needsExerciseSync: Bool = false
    ) {
        self.profileID = profileID
        self.date = date
        self.stepsCnt = stepsCnt
        self.stepsKcal = stepsKcal
        self.exerciseKcal = exerciseKcal
        self.exerciseSeconds = exerciseSeconds
        self.totalMealKcal = totalMealKcal
        self.isSeededFromServer = isSeededFromServer
        self.needsStepSync = needsStepSync
        self.needsExerciseSync = needsExerciseSync
    }

    private enum CodingKeys: String, CodingKey {
        case profileID, date, stepsCnt, stepsKcal, exerciseKcal, exerciseSeconds
        case totalMealKcal, isSeededFromServer, needsStepSync, needsExerciseSync
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        profileID = try container.decode(String.self, forKey: .profileID)
        date = try container.decode(String.self, forKey: .date)
        stepsCnt = try container.decode(Int.self, forKey: .stepsCnt)
        stepsKcal = try container.decode(Double.self, forKey: .stepsKcal)
        exerciseKcal = try container.decode(Double.self, forKey: .exerciseKcal)
        exerciseSeconds = try container.decode(Double.self, forKey: .exerciseSeconds)
        totalMealKcal = try container.decode(Int.self, forKey: .totalMealKcal)
        isSeededFromServer = try container.decode(Bool.self, forKey: .isSeededFromServer)

        // Drafts written before independent sync flags existed still contain activity
        // that the old rollover coordinator expected to submit.
        needsStepSync = try container.decodeIfPresent(Bool.self, forKey: .needsStepSync) ?? true
        needsExerciseSync = try container.decodeIfPresent(Bool.self, forKey: .needsExerciseSync)
            ?? (exerciseKcal > 0 || exerciseSeconds > 0)
    }
}

@MainActor
@Observable
final class CaloriesActivityStore {
    private(set) var drafts: [String: CaloriesActivityDraft]

    private let defaults: UserDefaults
    private let storageKey = "nutriscan.daily-activity-drafts.v1"
    private let syncedStepDatesKey = "nutriscan.daily-step-sync-receipts.v1"
    private let pendingFinalDatesKey = "nutriscan.daily-final-sync-pending.v1"
    private let lastActiveDatesKey = "nutriscan.daily-last-active-dates.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([String: CaloriesActivityDraft].self, from: data) {
            drafts = decoded
        } else {
            drafts = [:]
        }
    }

    func hasSyncedSteps(profileID: String, date: String) -> Bool {
        syncedStepDateIDs().contains(key(profileID: profileID, date: date))
    }

    func markStepDateSynced(profileID: String, date: String) {
        var synced = syncedStepDateIDs()
        synced.insert(key(profileID: profileID, date: date))
        defaults.set(Array(synced), forKey: syncedStepDatesKey)
        var pending = pendingFinalDateIDs()
        pending.remove(key(profileID: profileID, date: date))
        defaults.set(Array(pending), forKey: pendingFinalDatesKey)
    }

    func registerActiveDate(profileID: String, date: String) {
        var dates = lastActiveDates()
        if let previousDate = dates[profileID],
           previousDate < date,
           !hasSyncedSteps(profileID: profileID, date: previousDate) {
            markFinalSyncPending(profileID: profileID, date: previousDate)
        }
        dates[profileID] = date
        defaults.set(dates, forKey: lastActiveDatesKey)
    }

    func markFinalSyncPending(profileID: String, date: String) {
        guard !hasSyncedSteps(profileID: profileID, date: date) else { return }
        var pending = pendingFinalDateIDs()
        pending.insert(key(profileID: profileID, date: date))
        defaults.set(Array(pending), forKey: pendingFinalDatesKey)
    }

    func pendingFinalSyncDates(profileID: String, before date: String) -> [String] {
        let persistedDates = pendingFinalDateIDs().compactMap { identifier -> String? in
            let prefix = "\(profileID)|"
            guard identifier.hasPrefix(prefix) else { return nil }
            return String(identifier.dropFirst(prefix.count))
        }
        let legacyDates = drafts.values.compactMap { draft -> String? in
            guard draft.profileID == profileID, draft.needsStepSync else { return nil }
            return draft.date
        }
        return Set(persistedDates + legacyDates)
            .filter { $0 < date && !hasSyncedSteps(profileID: profileID, date: $0) }
            .sorted()
    }

    func draft(profileID: String, date: String) -> CaloriesActivityDraft? {
        drafts[key(profileID: profileID, date: date)]
    }

    @discardableResult
    func seedIfNeeded(profileID: String, tracking: CaloriesTracking) -> CaloriesActivityDraft {
        let draftKey = key(profileID: profileID, date: tracking.date)
        if var existing = drafts[draftKey] {
            guard !existing.isSeededFromServer else { return existing }
            existing.exerciseKcal += tracking.exerciseKcal
            existing.exerciseSeconds += tracking.exerciseMin * 60
            existing.totalMealKcal = tracking.mealCalories
            existing.isSeededFromServer = true
            drafts[draftKey] = existing
            persist()
            return existing
        }

        let draft = CaloriesActivityDraft(
            profileID: profileID,
            date: tracking.date,
            stepsCnt: 0,
            stepsKcal: 0,
            exerciseKcal: tracking.exerciseKcal,
            exerciseSeconds: tracking.exerciseMin * 60,
            totalMealKcal: tracking.mealCalories,
            isSeededFromServer: true,
            needsStepSync: false,
            needsExerciseSync: false
        )
        drafts[draftKey] = draft
        persist()
        return draft
    }

    func updateSteps(profileID: String, date: String, steps: Int, calories: Double) {
        let draftKey = key(profileID: profileID, date: date)
        if hasSyncedSteps(profileID: profileID, date: date) {
            if var draft = drafts[draftKey] {
                draft.needsStepSync = false
                drafts[draftKey] = draft
                if !draft.needsExerciseSync {
                    drafts.removeValue(forKey: draftKey)
                }
                persist()
            }
            return
        }
        var draft = drafts[draftKey] ?? CaloriesActivityDraft(
            profileID: profileID,
            date: date,
            stepsCnt: 0,
            stepsKcal: 0,
            exerciseKcal: 0,
            exerciseSeconds: 0,
            totalMealKcal: 0,
            isSeededFromServer: false,
            needsStepSync: false,
            needsExerciseSync: false
        )
        // The observer's latest value is authoritative; HealthKit can revise a
        // previously reported count downward after reconciling samples.
        draft.stepsCnt = max(steps, 0)
        draft.stepsKcal = max(calories, 0)
        draft.needsStepSync = true
        drafts[draftKey] = draft
        markFinalSyncPending(profileID: profileID, date: date)
        persist()
    }

    func updateMealCalories(profileID: String, date: String, calories: Int) {
        let draftKey = key(profileID: profileID, date: date)
        guard var draft = drafts[draftKey] else { return }
        draft.totalMealKcal = max(calories, 0)
        drafts[draftKey] = draft
        persist()
    }

    func recordWorkout(profileID: String, date: String, calories: Double, elapsedSeconds: Int) {
        let draftKey = key(profileID: profileID, date: date)
        var draft = drafts[draftKey] ?? CaloriesActivityDraft(
            profileID: profileID,
            date: date,
            stepsCnt: 0,
            stepsKcal: 0,
            exerciseKcal: 0,
            exerciseSeconds: 0,
            totalMealKcal: 0,
            isSeededFromServer: false,
            needsStepSync: false,
            needsExerciseSync: false
        )
        draft.exerciseKcal += max(calories, 0)
        draft.exerciseSeconds += Double(max(elapsedSeconds, 0))
        draft.needsExerciseSync = true
        drafts[draftKey] = draft
        persist()
    }

    func pendingStepDrafts(profileID: String, before date: String) -> [CaloriesActivityDraft] {
        drafts.values
            .filter {
                $0.profileID == profileID
                    && $0.date < date
                    && $0.needsStepSync
                    && !hasSyncedSteps(profileID: profileID, date: $0.date)
            }
            .sorted { $0.date < $1.date }
    }

    func cleanupReceiptBackedDrafts(profileID: String) {
        var changed = false
        for (draftKey, var draft) in drafts where draft.profileID == profileID {
            guard hasSyncedSteps(profileID: profileID, date: draft.date) else { continue }
            draft.needsStepSync = false
            if draft.needsExerciseSync {
                drafts[draftKey] = draft
            } else {
                drafts.removeValue(forKey: draftKey)
            }
            changed = true
        }
        if changed { persist() }
    }

    func pendingExerciseDrafts(profileID: String, through date: String) -> [CaloriesActivityDraft] {
        drafts.values
            .filter { $0.profileID == profileID && $0.date <= date && $0.needsExerciseSync }
            .sorted { $0.date < $1.date }
    }

    func markStepSynced(profileID: String, date: String) {
        markStepDateSynced(profileID: profileID, date: date)
        let draftKey = key(profileID: profileID, date: date)
        guard var draft = drafts[draftKey] else { return }
        draft.needsStepSync = false
        drafts[draftKey] = draft
        persist()
    }

    func markExerciseSynced(
        profileID: String,
        date: String,
        expectedCalories: Double,
        expectedSeconds: Double
    ) {
        let draftKey = key(profileID: profileID, date: date)
        guard var draft = drafts[draftKey] else { return }
        if draft.exerciseKcal == expectedCalories && draft.exerciseSeconds == expectedSeconds {
            draft.needsExerciseSync = false
            drafts[draftKey] = draft
            persist()
        }
    }

    func removeIfFullySynced(profileID: String, date: String) {
        guard let draft = draft(profileID: profileID, date: date),
              !draft.needsStepSync,
              !draft.needsExerciseSync else { return }
        remove(profileID: profileID, date: date)
    }

    func removeFullySyncedDrafts(profileID: String, before date: String) {
        let keysToRemove: [String] = drafts.compactMap { entry -> String? in
            let (key, draft) = entry
            guard draft.profileID == profileID,
                  draft.date < date,
                  !draft.needsStepSync,
                  !draft.needsExerciseSync else { return nil }
            return key
        }
        guard !keysToRemove.isEmpty else { return }
        keysToRemove.forEach { drafts.removeValue(forKey: $0) }
        persist()
    }

    func remove(profileID: String, date: String) {
        drafts.removeValue(forKey: key(profileID: profileID, date: date))
        persist()
    }

    private func key(profileID: String, date: String) -> String {
        "\(profileID)|\(date)"
    }

    private func syncedStepDateIDs() -> Set<String> {
        Set(defaults.stringArray(forKey: syncedStepDatesKey) ?? [])
    }

    private func pendingFinalDateIDs() -> Set<String> {
        Set(defaults.stringArray(forKey: pendingFinalDatesKey) ?? [])
    }

    private func lastActiveDates() -> [String: String] {
        defaults.dictionary(forKey: lastActiveDatesKey) as? [String: String] ?? [:]
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(drafts) else { return }
        defaults.set(data, forKey: storageKey)
    }
}
