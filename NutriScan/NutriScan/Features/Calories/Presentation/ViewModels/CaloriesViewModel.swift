//
//  CaloriesViewModel.swift
//  NutriScan
//
//  Created by albaraa alsayed on 22/07/2026.
//

import Foundation

@Observable
@MainActor
final class CaloriesViewModel {

    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private(set) var dailyTracking: DailyTracking?
    private(set) var isUpdatingWater = false

    var dailyKcal: Int   { dailyTracking?.totalCalories ?? 0 }
    var meals: [Meal]    { dailyTracking?.meals ?? [] }
    var waterCurrent: Int { dailyTracking?.waterCnt ?? 0 }
    var waterGoal: Int   { dailyTracking?.targetWaterCnt ?? 8 }

    var calorieGoal: Double? { profileStore.currentProfile?.tdee }
    var exerciseKcal: Int { todayDraft?.exerciseKcal ?? dailyTracking?.exerciseKcal ?? 0 }
    var exerciseMinutes: Double { todayDraft?.exerciseMin ?? dailyTracking?.exerciseMin ?? 0 }
    var stepsKcal: Int { todayDraft?.stepsKcal ?? dailyTracking?.stepsKcal ?? 0 }
    var totalBurnedKcal: Int { stepsKcal + exerciseKcal }
    var netCalories: Int { max(dailyKcal - totalBurnedKcal, 0) }

    private var profileID: String? { profileStore.currentProfile?.id }
    private var todayDraft: DailyActivityDraft? {
        guard let profileID else { return nil }
        return activityStore.draft(profileID: profileID, date: DailyTracking.todayString)
    }

    private let getTodayTrackingUseCase: GetTodayTrackingUseCase
    private let addMealUseCase: AddMealUseCase
    private let deleteMealUseCase: DeleteMealUseCase
    private let updateMealUseCase: UpdateMealUseCase
    private let updateWaterUseCase: UpdateWaterUseCase
    private let activityStore: DailyActivityStore
    private let profileStore: UserProfileStore
    private let activitySyncCoordinator: DailyActivitySyncCoordinator

    init(
        getTodayTrackingUseCase: GetTodayTrackingUseCase = DIContainer.shared.resolve(type: GetTodayTrackingUseCase.self),
        addMealUseCase: AddMealUseCase = DIContainer.shared.resolve(type: AddMealUseCase.self),
        deleteMealUseCase: DeleteMealUseCase = DIContainer.shared.resolve(type: DeleteMealUseCase.self),
        updateMealUseCase: UpdateMealUseCase = DIContainer.shared.resolve(type: UpdateMealUseCase.self),
        updateWaterUseCase: UpdateWaterUseCase = DIContainer.shared.resolve(type: UpdateWaterUseCase.self),
        activityStore: DailyActivityStore = DIContainer.shared.resolve(type: DailyActivityStore.self),
        profileStore: UserProfileStore = DIContainer.shared.resolve(type: UserProfileStore.self),
        activitySyncCoordinator: DailyActivitySyncCoordinator = DIContainer.shared.resolve(type: DailyActivitySyncCoordinator.self)
    ) {
        self.getTodayTrackingUseCase = getTodayTrackingUseCase
        self.addMealUseCase = addMealUseCase
        self.deleteMealUseCase = deleteMealUseCase
        self.updateMealUseCase = updateMealUseCase
        self.updateWaterUseCase = updateWaterUseCase
        self.activityStore = activityStore
        self.profileStore = profileStore
        self.activitySyncCoordinator = activitySyncCoordinator
    }

    func onAppear() {
        Task {
            await activitySyncCoordinator.synchronizePendingDates()
            await fetchTodayTracking()
        }
    }

    func fetchTodayTracking() async {
        isLoading = true
        errorMessage = nil
        do {
            let tracking = try await getTodayTrackingUseCase.execute()
            dailyTracking = tracking
            if let profileID {
                activityStore.seedIfNeeded(profileID: profileID, tracking: tracking)
                activityStore.updateMealCalories(
                    profileID: profileID,
                    date: tracking.date,
                    calories: tracking.totalCalories
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func fillCup(index: Int) {
        guard !isUpdatingWater, index < waterGoal else { return }
        let newWaterCnt = index + 1
        guard let current = dailyTracking, newWaterCnt > current.waterCnt else { return }
        Task { await mutateWater(target: nil, water: newWaterCnt) }
    }

    func removeConsumedCup() {
        guard !isUpdatingWater, let current = dailyTracking, current.waterCnt > 0 else { return }
        Task { await mutateWater(target: nil, water: current.waterCnt - 1) }
    }

    func addTargetCup() {
        guard !isUpdatingWater, let current = dailyTracking else { return }
        let newTarget = current.targetWaterCnt + 1
        Task { await mutateWater(target: newTarget, water: current.waterCnt) }
    }

    func removeTargetCup() {
        guard !isUpdatingWater, let current = dailyTracking, current.targetWaterCnt > 1 else { return }
        let newTarget = current.targetWaterCnt - 1
        let clampedWater = min(current.waterCnt, newTarget)
        Task { await mutateWater(target: newTarget, water: clampedWater) }
    }

    func updateSteps(_ steps: Int, calories: Int) {
        guard let profileID else { return }
        if dailyTracking != nil && todayDraft == nil, let dailyTracking {
            activityStore.seedIfNeeded(profileID: profileID, tracking: dailyTracking)
        }
        activityStore.updateSteps(
            profileID: profileID,
            date: DailyTracking.todayString,
            steps: steps,
            calories: calories
        )
    }

    func removeOneMeal(scanId: String) {
        guard let meal = meals.first(where: { $0.scanId == scanId }), meal.mealCnt > 1 else { return }
        Task {
            do {
                _ = try await updateMealUseCase.execute(
                    date: DailyTracking.todayString,
                    scanId: scanId,
                    mealCnt: meal.mealCnt - 1
                )
                await fetchTodayTracking()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func deleteMeal(scanId: String) {
        Task {
            do {
                try await deleteMealUseCase.execute(date: DailyTracking.todayString, scanId: scanId)
                await fetchTodayTracking()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func addFood() {
    }

    func dismissError() {
        errorMessage = nil
    }

    private func mutateWater(target: Int?, water: Int) async {
        guard let current = dailyTracking, !isUpdatingWater else { return }
        isUpdatingWater = true
        dailyTracking = copy(
            current,
            targetWaterCnt: target ?? current.targetWaterCnt,
            waterCnt: water
        )
        do {
            dailyTracking = try await updateWaterUseCase.execute(
                date: current.date,
                targetWaterCnt: target,
                waterCnt: water
            )
        } catch {
            dailyTracking = current
            errorMessage = error.localizedDescription
        }
        isUpdatingWater = false
    }

    private func copy(_ tracking: DailyTracking, targetWaterCnt: Int, waterCnt: Int) -> DailyTracking {
        DailyTracking(
            id: tracking.id,
            date: tracking.date,
            targetWaterCnt: targetWaterCnt,
            waterCnt: waterCnt,
            stepsCnt: tracking.stepsCnt,
            stepsKcal: tracking.stepsKcal,
            exerciseKcal: tracking.exerciseKcal,
            exerciseMin: tracking.exerciseMin,
            totalMealKcal: tracking.totalMealKcal,
            meals: tracking.meals
        )
    }
}

@Observable
@MainActor
final class DailyActivitySyncCoordinator {
    private(set) var isSyncing = false
    private(set) var lastError: String?

    private let activityStore: DailyActivityStore
    private let profileStore: UserProfileStore
    private let getTrackingByDateUseCase: GetTrackingByDateUseCase
    private let updateTrackingUseCase: UpdateWaterUseCase
    private let fetchHistoryUseCase: FetchStepsHistoryUseCaseProtocol

    init(
        activityStore: DailyActivityStore,
        profileStore: UserProfileStore,
        getTrackingByDateUseCase: GetTrackingByDateUseCase,
        updateTrackingUseCase: UpdateWaterUseCase,
        fetchHistoryUseCase: FetchStepsHistoryUseCaseProtocol
    ) {
        self.activityStore = activityStore
        self.profileStore = profileStore
        self.getTrackingByDateUseCase = getTrackingByDateUseCase
        self.updateTrackingUseCase = updateTrackingUseCase
        self.fetchHistoryUseCase = fetchHistoryUseCase
    }

    func synchronizePendingDates() async {
        guard !isSyncing, let profile = profileStore.currentProfile else { return }
        isSyncing = true
        lastError = nil
        defer { isSyncing = false }

        let pending = activityStore.pendingDrafts(
            profileID: profile.id,
            before: DailyTracking.todayString
        )

        for draft in pending {
            do {
                let tracking = try await getTrackingByDateUseCase.execute(date: draft.date)
                let steps = await refreshedSteps(for: draft) ?? draft.stepsCnt
                let stepCalories = StepAnalyticsCalculator(
                    weightKg: profile.weightKg ?? 70,
                    heightCm: profile.heightCm ?? 170
                ).caloriesBurned(steps: steps)
                let exerciseKcal = draft.isSeededFromServer
                    ? max(draft.exerciseKcal, tracking.exerciseKcal)
                    : draft.exerciseKcal + tracking.exerciseKcal
                let exerciseMin = draft.isSeededFromServer
                    ? max(draft.exerciseMin, tracking.exerciseMin)
                    : draft.exerciseMin + tracking.exerciseMin

                _ = try await updateTrackingUseCase.execute(
                    date: draft.date,
                    targetWaterCnt: tracking.targetWaterCnt,
                    waterCnt: tracking.waterCnt,
                    stepsCnt: steps,
                    stepsKcal: stepCalories,
                    exerciseKcal: exerciseKcal,
                    exerciseMin: exerciseMin,
                    totalMealKcal: tracking.totalCalories
                )
                activityStore.remove(profileID: profile.id, date: draft.date)
            } catch {
                lastError = error.localizedDescription
            }
        }
    }

    private func refreshedSteps(for draft: DailyActivityDraft) async -> Int? {
        guard let date = DailyTracking.date(from: draft.date) else { return nil }
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start
        guard let history = try? await fetchHistoryUseCase.execute(from: start, to: end) else {
            return nil
        }
        return history.first(where: { calendar.isDate($0.date, inSameDayAs: start) })?.stepCount
    }
}
