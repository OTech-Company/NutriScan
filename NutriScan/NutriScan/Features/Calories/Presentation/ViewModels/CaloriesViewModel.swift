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

    var dailyKcal: Int   { caloriesTracking?.mealCalories ?? 0 }
    var meals: [CalorieMeal]    { caloriesTracking?.meals ?? [] }
    var waterCurrent: Int { caloriesTracking?.waterCnt ?? 0 }
    var waterGoal: Int   { caloriesTracking?.targetWaterCnt ?? 8 }

    var calorieGoal: Double? { profileStore.currentProfile?.tdee }
    var exerciseKcal: Double { todayDraft?.exerciseKcal ?? caloriesTracking?.exerciseKcal ?? 0 }
    var exerciseMinutes: Double { todayDraft?.exerciseMin ?? caloriesTracking?.exerciseMin ?? 0 }
    var stepsKcal: Double { todayDraft?.stepsKcal ?? caloriesTracking?.stepsKcal ?? 0 }
    var totalBurnedKcal: Double { stepsKcal + exerciseKcal }
    var netCalories: Double { max(Double(dailyKcal) - totalBurnedKcal, 0) }

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
    private let notificationScheduler: SmartNotificationSchedulerProtocol

    init(
        getTodayCaloriesTrackingUseCase: GetTodayCaloriesTrackingUseCaseProtocol,
        addMealUseCase: AddCaloriesMealUseCaseProtocol,
        deleteMealUseCase: DeleteMealUseCaseProtocol,
        updateMealUseCase: UpdateMealUseCaseProtocol,
        updateWaterUseCase: UpdateWaterUseCaseProtocol,
        caloriesActivityStore: CaloriesActivityStore,
        profileStore: UserProfileStore,
        caloriesActivitySyncCoordinator: CaloriesActivitySyncCoordinator,
        notificationScheduler: SmartNotificationSchedulerProtocol
    ) {
        self.getTodayCaloriesTrackingUseCase = getTodayCaloriesTrackingUseCase
        self.addMealUseCase = addMealUseCase
        self.deleteMealUseCase = deleteMealUseCase
        self.updateMealUseCase = updateMealUseCase
        self.updateWaterUseCase = updateWaterUseCase
        self.caloriesActivityStore = caloriesActivityStore
        self.profileStore = profileStore
        self.caloriesActivitySyncCoordinator = caloriesActivitySyncCoordinator
        self.notificationScheduler = notificationScheduler
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
        defer { isLoading = false }
        do {
            let tracking = try await getTodayCaloriesTrackingUseCase.execute()
            caloriesTracking = tracking
            await evaluateSmartNotificationCancellations(for: tracking)
            if let profileID {
                caloriesActivityStore.seedIfNeeded(profileID: profileID, tracking: tracking)
                caloriesActivityStore.updateMealCalories(
                    profileID: profileID,
                    date: tracking.date,
                    calories: tracking.mealCalories
                )
            }
        } catch {
            guard !isCancellation(error) else { return }
            errorMessage = error.localizedDescription
        }
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
            calories: Double(calories)
        )
        Task {
            let nowHour = Calendar.current.component(.hour, from: Date())
            if nowHour < 16 && steps >= 4000 {
                await notificationScheduler.cancelAfternoonStepsMove()
            }
        }
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
                guard !isCancellation(error) else { return }
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
                guard !isCancellation(error) else { return }
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
            let updated = try await updateWaterUseCase.execute(
                date: current.date,
                targetWaterCnt: target,
                waterCnt: water,
                stepsCnt: nil,
                stepsKcal: nil,
                exerciseKcal: nil,
                exerciseMin: nil
            )
            caloriesTracking = updated
            await evaluateSmartNotificationCancellations(for: updated)
        } catch {
            guard !isCancellation(error) else {
                caloriesTracking = current
                isUpdatingWater = false
                return
            }
            caloriesTracking = current
            errorMessage = error.localizedDescription
        }
        isUpdatingWater = false
    }

    private func evaluateSmartNotificationCancellations(for tracking: CaloriesTracking) async {
        let nowComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let hour = nowComponents.hour ?? 0
        let minute = nowComponents.minute ?? 0

        // 1. 🍳 Breakfast: Logged any meal before 09:00 AM
        if hour < 9 && !tracking.meals.isEmpty {
            await notificationScheduler.cancelBreakfastNudge()
        }

        // 2. 🥗 Lunch: Logged >= 2 meals before 13:30 PM
        let isBeforeLunch = (hour < 13) || (hour == 13 && minute < 30)
        if isBeforeLunch && tracking.meals.count >= 2 {
            await notificationScheduler.cancelLunchNudge()
        }

        // 3. 🍲 Dinner: Logged >= 3 meals or calories >= 1200 before 19:30 PM
        let isBeforeDinner = (hour < 19) || (hour == 19 && minute < 30)
        if isBeforeDinner && (tracking.meals.count >= 3 || tracking.mealCalories >= 1200) {
            await notificationScheduler.cancelDinnerNudge()
        }

        // 4. 🔥 Streak Protection: Logged meals & calories > 0 before 21:30 PM
        let isBeforeStreak = (hour < 21) || (hour == 21 && minute < 30)
        if isBeforeStreak && !tracking.meals.isEmpty && tracking.mealCalories > 0 {
            await notificationScheduler.cancelStreakProtection()
        }

        // 5. 💧 Water Pace Reminders
        if hour < 11 && tracking.waterCnt >= 2 {
            await notificationScheduler.cancelMorningWaterPace()
        }
        if hour < 14 && tracking.waterCnt >= 4 {
            await notificationScheduler.cancelMiddayWaterPace()
        }
        if hour < 17 && tracking.waterCnt >= 6 {
            await notificationScheduler.cancelEveningWaterPace()
        }

        // 6. 🏃‍♂️ Afternoon Steps Move
        if hour < 16 && tracking.stepsCnt >= 4000 {
            await notificationScheduler.cancelAfternoonStepsMove()
        }

        // 7. 🏋️‍♂️ Workout Nudge
        let isBeforeWorkout = (hour < 20) || (hour == 20 && minute < 30)
        if isBeforeWorkout && (tracking.exerciseMin > 0 || tracking.exerciseKcal > 0) {
            await notificationScheduler.cancelWorkoutNudge()
        }
    }

    private func isCancellation(_ error: Error) -> Bool {
        if error is CancellationError { return true }
        if let urlError = error as? URLError, urlError.code == .cancelled { return true }
        if case NetworkError.unknown(let wrappedError) = error {
            return isCancellation(wrappedError)
        }
        return false
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
                let normalizedDraft = caloriesActivityStore.seedIfNeeded(profileID: profile.id, tracking: tracking)
                let steps = await refreshedSteps(for: normalizedDraft) ?? normalizedDraft.stepsCnt
                let stepCalories = Double(StepAnalyticsCalculator(
                    weightKg: profile.weightKg ?? 70,
                    heightCm: profile.heightCm ?? 170
                ).caloriesBurned(steps: steps))

                _ = try await updateWaterUseCase.execute(
                    date: normalizedDraft.date,
                    targetWaterCnt: tracking.targetWaterCnt,
                    waterCnt: tracking.waterCnt,
                    stepsCnt: steps,
                    stepsKcal: stepCalories,
                    exerciseKcal: normalizedDraft.exerciseKcal,
                    exerciseMin: normalizedDraft.exerciseMin
                )
                caloriesActivityStore.remove(profileID: profile.id, date: normalizedDraft.date)
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
