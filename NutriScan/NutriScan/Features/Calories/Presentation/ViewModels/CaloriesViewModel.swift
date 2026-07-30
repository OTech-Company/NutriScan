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

    private(set) var caloriesTracking: CaloriesTracking?
    private(set) var isUpdatingWater = false

    var dailyKcal: Int   { caloriesTracking?.totalCalories ?? 0 }
    var meals: [CalorieMeal]    { caloriesTracking?.meals ?? [] }
    var waterCurrent: Int { caloriesTracking?.waterCnt ?? 0 }
    var waterGoal: Int   { caloriesTracking?.targetWaterCnt ?? 8 }

    var calorieGoal: Double? { profileStore.currentProfile?.tdee }
    var exerciseKcal: Int { todayDraft?.exerciseKcal ?? caloriesTracking?.exerciseKcal ?? 0 }
    var exerciseMinutes: Double { todayDraft?.exerciseMin ?? caloriesTracking?.exerciseMin ?? 0 }
    var stepsKcal: Int { todayDraft?.stepsKcal ?? caloriesTracking?.stepsKcal ?? 0 }
    var totalBurnedKcal: Int { stepsKcal + exerciseKcal }
    var netCalories: Int { max(dailyKcal - totalBurnedKcal, 0) }

    private var profileID: String? { profileStore.currentProfile?.id }
    private var todayDraft: CaloriesActivityDraft? {
        guard let profileID else { return nil }
        return caloriesActivityStore.draft(profileID: profileID, date: CaloriesTracking.todayString)
    }

    private let getTodayCaloriesTrackingUseCase: GetTodayCaloriesTrackingUseCaseProtocol
    private let addMealUseCase: AddCaloriesMealUseCaseProtocol
    private let deleteMealUseCase: DeleteMealUseCaseProtocol
    private let updateMealUseCase: UpdateMealUseCaseProtocol
    private let updateWaterUseCase: UpdateWaterUseCaseProtocol
    private let caloriesActivityStore: CaloriesActivityStore
    private let profileStore: UserProfileStore
    private let caloriesActivitySyncCoordinator: CaloriesActivitySyncCoordinator

    init(
        getTodayCaloriesTrackingUseCase: GetTodayCaloriesTrackingUseCaseProtocol = DIContainer.shared.resolve(type: GetTodayCaloriesTrackingUseCaseProtocol.self),
        addMealUseCase: AddCaloriesMealUseCaseProtocol = DIContainer.shared.resolve(type: AddCaloriesMealUseCaseProtocol.self),
        deleteMealUseCase: DeleteMealUseCaseProtocol = DIContainer.shared.resolve(type: DeleteMealUseCaseProtocol.self),
        updateMealUseCase: UpdateMealUseCaseProtocol = DIContainer.shared.resolve(type: UpdateMealUseCaseProtocol.self),
        updateWaterUseCase: UpdateWaterUseCaseProtocol = DIContainer.shared.resolve(type: UpdateWaterUseCaseProtocol.self),
        caloriesActivityStore: CaloriesActivityStore = DIContainer.shared.resolve(type: CaloriesActivityStore.self),
        profileStore: UserProfileStore = DIContainer.shared.resolve(type: UserProfileStore.self),
        caloriesActivitySyncCoordinator: CaloriesActivitySyncCoordinator = DIContainer.shared.resolve(type: CaloriesActivitySyncCoordinator.self)
    ) {
        self.getTodayCaloriesTrackingUseCase = getTodayCaloriesTrackingUseCase
        self.addMealUseCase = addMealUseCase
        self.deleteMealUseCase = deleteMealUseCase
        self.updateMealUseCase = updateMealUseCase
        self.updateWaterUseCase = updateWaterUseCase
        self.caloriesActivityStore = caloriesActivityStore
        self.profileStore = profileStore
        self.caloriesActivitySyncCoordinator = caloriesActivitySyncCoordinator
    }

    func onAppear() {
        Task {
            await caloriesActivitySyncCoordinator.synchronizePendingDates()
            await fetchTodayTracking()
        }
    }

    func fetchTodayTracking() async {
        isLoading = true
        errorMessage = nil
        do {
            let tracking = try await getTodayCaloriesTrackingUseCase.execute()
            caloriesTracking = tracking
            if let profileID {
                caloriesActivityStore.seedIfNeeded(profileID: profileID, tracking: tracking)
                caloriesActivityStore.updateMealCalories(
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
        guard let current = caloriesTracking, newWaterCnt > current.waterCnt else { return }
        Task { await mutateWater(target: nil, water: newWaterCnt) }
    }

    func removeConsumedCup() {
        guard !isUpdatingWater, let current = caloriesTracking, current.waterCnt > 0 else { return }
        Task { await mutateWater(target: nil, water: current.waterCnt - 1) }
    }

    func addTargetCup() {
        guard !isUpdatingWater, let current = caloriesTracking else { return }
        let newTarget = current.targetWaterCnt + 1
        Task { await mutateWater(target: newTarget, water: current.waterCnt) }
    }

    func removeTargetCup() {
        guard !isUpdatingWater, let current = caloriesTracking, current.targetWaterCnt > 1 else { return }
        let newTarget = current.targetWaterCnt - 1
        let clampedWater = min(current.waterCnt, newTarget)
        Task { await mutateWater(target: newTarget, water: clampedWater) }
    }

    func updateSteps(_ steps: Int, calories: Int) {
        guard let profileID else { return }
        if caloriesTracking != nil && todayDraft == nil, let caloriesTracking {
            caloriesActivityStore.seedIfNeeded(profileID: profileID, tracking: caloriesTracking)
        }
        caloriesActivityStore.updateSteps(
            profileID: profileID,
            date: CaloriesTracking.todayString,
            steps: steps,
            calories: calories
        )
    }

    func removeOneMeal(scanId: String) {
        guard let meal = meals.first(where: { $0.scanId == scanId }), meal.mealCnt > 1 else { return }
        Task {
            do {
                _ = try await updateMealUseCase.execute(
                    date: CaloriesTracking.todayString,
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
                try await deleteMealUseCase.execute(date: CaloriesTracking.todayString, scanId: scanId)
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
        guard let current = caloriesTracking, !isUpdatingWater else { return }
        isUpdatingWater = true
        caloriesTracking = copy(
            current,
            targetWaterCnt: target ?? current.targetWaterCnt,
            waterCnt: water
        )
        do {
            caloriesTracking = try await updateWaterUseCase.execute(
                date: current.date,
                targetWaterCnt: target,
                waterCnt: water,
                stepsCnt: nil,
                stepsKcal: nil,
                exerciseKcal: nil,
                exerciseMin: nil,
                totalMealKcal: nil
            )
        } catch {
            caloriesTracking = current
            errorMessage = error.localizedDescription
        }
        isUpdatingWater = false
    }

    private func copy(_ tracking: CaloriesTracking, targetWaterCnt: Int, waterCnt: Int) -> CaloriesTracking {
        CaloriesTracking(
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
final class CaloriesActivitySyncCoordinator {
    private(set) var isSyncing = false
    private(set) var lastError: String?

    private let caloriesActivityStore: CaloriesActivityStore
    private let profileStore: UserProfileStore
    private let getCaloriesTrackingByDateUseCase: GetCaloriesTrackingByDateUseCaseProtocol
    private let updateWaterUseCase: UpdateWaterUseCaseProtocol
    private let fetchHistoryUseCase: FetchStepsHistoryUseCaseProtocol

    init(
        caloriesActivityStore: CaloriesActivityStore,
        profileStore: UserProfileStore,
        getCaloriesTrackingByDateUseCase: GetCaloriesTrackingByDateUseCaseProtocol,
        updateWaterUseCase: UpdateWaterUseCaseProtocol,
        fetchHistoryUseCase: FetchStepsHistoryUseCaseProtocol
    ) {
        self.caloriesActivityStore = caloriesActivityStore
        self.profileStore = profileStore
        self.getCaloriesTrackingByDateUseCase = getCaloriesTrackingByDateUseCase
        self.updateWaterUseCase = updateWaterUseCase
        self.fetchHistoryUseCase = fetchHistoryUseCase
    }

    func synchronizePendingDates() async {
        guard !isSyncing, let profile = profileStore.currentProfile else { return }
        isSyncing = true
        lastError = nil
        defer { isSyncing = false }

        let pending = caloriesActivityStore.pendingDrafts(
            profileID: profile.id,
            before: CaloriesTracking.todayString
        )

        for draft in pending {
            do {
                let tracking = try await getCaloriesTrackingByDateUseCase.execute(date: draft.date)
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

                _ = try await updateWaterUseCase.execute(
                    date: draft.date,
                    targetWaterCnt: tracking.targetWaterCnt,
                    waterCnt: tracking.waterCnt,
                    stepsCnt: steps,
                    stepsKcal: stepCalories,
                    exerciseKcal: exerciseKcal,
                    exerciseMin: exerciseMin,
                    totalMealKcal: tracking.totalCalories
                )
                caloriesActivityStore.remove(profileID: profile.id, date: draft.date)
            } catch {
                lastError = error.localizedDescription
            }
        }
    }

    private func refreshedSteps(for draft: CaloriesActivityDraft) async -> Int? {
        guard let date = CaloriesTracking.date(from: draft.date) else { return nil }
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start
        guard let history = try? await fetchHistoryUseCase.execute(from: start, to: end) else {
            return nil
        }
        return history.first(where: { calendar.isDate($0.date, inSameDayAs: start) })?.stepCount
    }
}
