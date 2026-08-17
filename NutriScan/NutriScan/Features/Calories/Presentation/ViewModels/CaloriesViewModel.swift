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

    private(set) var isInitialLoading = true
    private(set) var isRefreshing = false
    private(set) var hasCompletedInitialLoad = false
    private(set) var errorMessage: String?

    private(set) var caloriesTracking: CaloriesTracking?
    private(set) var isUpdatingWater = false
    private(set) var loadedDate: String?
    private(set) var mutatingMealIDs: Set<String> = []

    var dailyKcal: Int   { caloriesTracking?.mealCalories ?? 0 }
    var meals: [CalorieMeal]    { caloriesTracking?.meals ?? [] }
    var waterCurrent: Int { caloriesTracking?.waterCnt ?? 0 }
    var waterGoal: Int   { caloriesTracking?.targetWaterCnt ?? 8 }

    var calorieGoal: Double? { profileStore.currentProfile?.tdee }
    var exerciseKcal: Double { todayDraft?.exerciseKcal ?? caloriesTracking?.exerciseKcal ?? 0 }
    var exerciseMinutes: Double { todayDraft?.exerciseMin ?? caloriesTracking?.exerciseMin ?? 0 }
    var stepsKcal: Double { todayDraft?.stepsKcal ?? 0 }
    var totalBurnedKcal: Double { stepsKcal + exerciseKcal }
    var netCalories: Double { max(Double(dailyKcal) - totalBurnedKcal, 0) }

    private var profileID: String? { profileStore.currentProfile?.id }
    private var currentDateString: String {
        CaloriesTracking.dateString(from: dateProvider())
    }

    private var todayDraft: CaloriesActivityDraft? {
        guard let profileID else { return nil }
        return caloriesActivityStore.draft(profileID: profileID, date: currentDateString)
    }

    private let getCaloriesTrackingByDateUseCase: GetCaloriesTrackingByDateUseCaseProtocol
    private let addMealUseCase: AddCaloriesMealUseCaseProtocol
    private let deleteMealUseCase: DeleteMealUseCaseProtocol
    private let updateMealUseCase: UpdateMealUseCaseProtocol
    private let updateWaterUseCase: UpdateWaterUseCaseProtocol
    private let caloriesActivityStore: CaloriesActivityStore
    private let profileStore: UserProfileStore
    private let caloriesActivitySyncCoordinator: CaloriesActivitySyncCoordinator
    private let notificationScheduler: SmartNotificationSchedulerProtocol
    private let dateProvider: () -> Date
    private var loadGeneration = 0
    private var waterMutationID: UUID?
    private var contentMutationGeneration = 0

    init(
        getCaloriesTrackingByDateUseCase: GetCaloriesTrackingByDateUseCaseProtocol,
        addMealUseCase: AddCaloriesMealUseCaseProtocol,
        deleteMealUseCase: DeleteMealUseCaseProtocol,
        updateMealUseCase: UpdateMealUseCaseProtocol,
        updateWaterUseCase: UpdateWaterUseCaseProtocol,
        caloriesActivityStore: CaloriesActivityStore,
        profileStore: UserProfileStore,
        caloriesActivitySyncCoordinator: CaloriesActivitySyncCoordinator,
        notificationScheduler: SmartNotificationSchedulerProtocol,
        dateProvider: @escaping () -> Date = Date.init
    ) {
        self.getCaloriesTrackingByDateUseCase = getCaloriesTrackingByDateUseCase
        self.addMealUseCase = addMealUseCase
        self.deleteMealUseCase = deleteMealUseCase
        self.updateMealUseCase = updateMealUseCase
        self.updateWaterUseCase = updateWaterUseCase
        self.caloriesActivityStore = caloriesActivityStore
        self.profileStore = profileStore
        self.caloriesActivitySyncCoordinator = caloriesActivitySyncCoordinator
        self.notificationScheduler = notificationScheduler
        self.dateProvider = dateProvider
    }

    var needsDayRollover: Bool {
        guard let loadedDate else { return false }
        return loadedDate != currentDateString
    }

    func activate() async {
        let requestedDate = currentDateString
        if let profileID {
            caloriesActivityStore.registerActiveDate(profileID: profileID, date: requestedDate)
        }
        if loadedDate != requestedDate {
            loadGeneration += 1
            loadedDate = requestedDate
            caloriesTracking = emptyTracking(for: requestedDate)
            mutatingMealIDs.removeAll()
            waterMutationID = nil
            isUpdatingWater = false
        }

        async let synchronization: Void = caloriesActivitySyncCoordinator.synchronizePendingDates(
            before: requestedDate
        )
        await fetchTracking(for: requestedDate)
        await synchronization
    }

    func fetchTodayTracking() async {
        let requestedDate = currentDateString
        if let profileID {
            caloriesActivityStore.registerActiveDate(profileID: profileID, date: requestedDate)
        }
        if loadedDate != requestedDate {
            loadGeneration += 1
            loadedDate = requestedDate
            caloriesTracking = emptyTracking(for: requestedDate)
            mutatingMealIDs.removeAll()
            waterMutationID = nil
            isUpdatingWater = false
        }
        await fetchTracking(for: requestedDate)
    }

    private func fetchTracking(for requestedDate: String) async {
        loadGeneration += 1
        let generation = loadGeneration
        let mutationGeneration = contentMutationGeneration
        let initialLoad = !hasCompletedInitialLoad
        let minimumShimmerTask = initialLoad
            ? Task { try? await Task.sleep(for: .milliseconds(500)) }
            : nil
        if initialLoad {
            isInitialLoading = true
        } else {
            isRefreshing = true
        }
        var pendingErrorMessage: String?
        errorMessage = nil
        do {
            var tracking = sanitizeServerSteps(
                try await getCaloriesTrackingByDateUseCase.execute(date: requestedDate)
            )
            guard generation == loadGeneration,
                  mutationGeneration == contentMutationGeneration,
                  !isUpdatingWater,
                  mutatingMealIDs.isEmpty,
                  loadedDate == requestedDate,
                  currentDateString == requestedDate,
                  tracking.date == requestedDate else {
                await finishLoading(
                    generation: generation,
                    minimumShimmerTask: minimumShimmerTask
                )
                return
            }

            let needsDefaultWaterTarget = tracking.targetWaterCnt <= 0
            if needsDefaultWaterTarget {
                tracking = copy(
                    tracking,
                    targetWaterCnt: 8,
                    waterCnt: tracking.waterCnt
                )
            }

            caloriesTracking = tracking
            hasCompletedInitialLoad = true
            await evaluateSmartNotificationCancellations(for: tracking)
            if let profileID {
                caloriesActivityStore.seedIfNeeded(profileID: profileID, tracking: tracking)
                caloriesActivityStore.updateMealCalories(
                    profileID: profileID,
                    date: tracking.date,
                    calories: tracking.mealCalories
                )
            }

            if needsDefaultWaterTarget {
                do {
                    try await updateWaterUseCase.execute(
                        date: requestedDate,
                        targetWaterCnt: 8,
                        waterCnt: nil,
                        stepsCnt: nil,
                        stepsKcal: nil,
                        exerciseKcal: nil,
                        exerciseMin: nil
                    )
                } catch {
                    if generation == loadGeneration,
                       loadedDate == requestedDate,
                       currentDateString == requestedDate,
                       !isCancellation(error) {
                        pendingErrorMessage = error.localizedDescription
                    }
                }
            }
        } catch {
            if generation == loadGeneration,
               loadedDate == requestedDate,
               !isCancellation(error) {
                pendingErrorMessage = error.localizedDescription
            }
        }

        await finishLoading(
            generation: generation,
            minimumShimmerTask: minimumShimmerTask
        )
        if generation == loadGeneration, let pendingErrorMessage {
            errorMessage = pendingErrorMessage
        }
    }

    private func finishLoading(
        generation: Int,
        minimumShimmerTask: Task<Void?, Never>?
    ) async {
        if let minimumShimmerTask { _ = await minimumShimmerTask.value }
        if generation == loadGeneration {
            isInitialLoading = false
            isRefreshing = false
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
        updateSteps(steps, calories: calories, for: loadedDate ?? currentDateString)
    }

    func updateSteps(_ steps: Int, calories: Int, for date: String) {
        guard let profileID else { return }
        if caloriesTracking?.date == date,
           caloriesActivityStore.draft(profileID: profileID, date: date) == nil,
           let caloriesTracking {
            caloriesActivityStore.seedIfNeeded(profileID: profileID, tracking: caloriesTracking)
        }
        caloriesActivityStore.updateSteps(
            profileID: profileID,
            date: date,
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

    func removeOneMeal(scanId: String) async {
        guard !mutatingMealIDs.contains(scanId),
              let current = caloriesTracking,
              current.date == loadedDate,
              let originalIndex = current.meals.firstIndex(where: { $0.scanId == scanId }),
              current.meals[originalIndex].mealCnt > 1 else { return }

        let originalMeal = current.meals[originalIndex]
        let requestDate = current.date
        mutatingMealIDs.insert(scanId)
        defer { mutatingMealIDs.remove(scanId) }
        replaceMeal(
            originalMeal,
            withCount: originalMeal.mealCnt - 1,
            in: requestDate
        )

        do {
            let updatedMeal = try await updateMealUseCase.execute(
                date: requestDate,
                scanId: scanId,
                mealCnt: originalMeal.mealCnt - 1
            )
            guard caloriesTracking?.date == requestDate else { return }
            replaceMeal(updatedMeal, in: requestDate)
        } catch {
            guard caloriesTracking?.date == requestDate else { return }
            restoreMeal(originalMeal, originalIndex: originalIndex, in: requestDate)
            if !isCancellation(error) {
                errorMessage = error.localizedDescription
            }
        }
    }

    func deleteMeal(scanId: String) async {
        guard !mutatingMealIDs.contains(scanId),
              let current = caloriesTracking,
              current.date == loadedDate,
              let originalIndex = current.meals.firstIndex(where: { $0.scanId == scanId }) else { return }

        let originalMeal = current.meals[originalIndex]
        let requestDate = current.date
        mutatingMealIDs.insert(scanId)
        defer { mutatingMealIDs.remove(scanId) }
        removeMeal(scanId: scanId, from: requestDate)

        do {
            try await deleteMealUseCase.execute(date: requestDate, scanId: scanId)
            if caloriesTracking?.date == requestDate {
                contentMutationGeneration += 1
            }
        } catch {
            guard caloriesTracking?.date == requestDate else { return }
            restoreMeal(originalMeal, originalIndex: originalIndex, in: requestDate)
            if !isCancellation(error) {
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
        let requestDate = current.date
        let requestGeneration = loadGeneration
        let mutationID = UUID()
        waterMutationID = mutationID
        contentMutationGeneration += 1
        isUpdatingWater = true
        let optimisticTracking = copy(
            current,
            targetWaterCnt: target ?? current.targetWaterCnt,
            waterCnt: water
        )
        caloriesTracking = optimisticTracking
        defer {
            if waterMutationID == mutationID {
                waterMutationID = nil
                isUpdatingWater = false
            }
        }
        do {
            try await updateWaterUseCase.execute(
                date: requestDate,
                targetWaterCnt: target,
                waterCnt: water,
                stepsCnt: nil,
                stepsKcal: nil,
                exerciseKcal: nil,
                exerciseMin: nil
            )
            guard waterMutationID == mutationID,
                  requestGeneration == loadGeneration,
                  loadedDate == requestDate,
                  currentDateString == requestDate,
                  caloriesTracking?.date == requestDate else { return }
            contentMutationGeneration += 1
            await evaluateSmartNotificationCancellations(for: optimisticTracking)
        } catch {
            guard waterMutationID == mutationID,
                  requestGeneration == loadGeneration,
                  loadedDate == requestDate,
                  currentDateString == requestDate,
                  caloriesTracking?.date == requestDate else { return }
            caloriesTracking = current
            contentMutationGeneration += 1
            if !isCancellation(error) {
                errorMessage = error.localizedDescription
            }
        }
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

    private func emptyTracking(for date: String) -> CaloriesTracking {
        CaloriesTracking(
            id: 0,
            date: date,
            targetWaterCnt: 8,
            waterCnt: 0,
            stepsCnt: 0,
            stepsKcal: 0,
            exerciseKcal: 0,
            exerciseMin: 0,
            totalMealKcal: 0,
            meals: []
        )
    }

    private func replaceMeal(_ meal: CalorieMeal, withCount count: Int, in date: String) {
        replaceMeal(
            CalorieMeal(
                scanId: meal.scanId,
                productName: meal.productName,
                imageUrl: meal.imageUrl,
                mealCnt: count,
                nutritionFacts: meal.nutritionFacts
            ),
            in: date
        )
    }

    private func replaceMeal(_ meal: CalorieMeal, in date: String) {
        guard let current = caloriesTracking,
              current.date == date,
              let index = current.meals.firstIndex(where: { $0.scanId == meal.scanId }) else { return }
        var updatedMeals = current.meals
        updatedMeals[index] = meal
        applyMeals(updatedMeals, to: current)
    }

    private func removeMeal(scanId: String, from date: String) {
        guard let current = caloriesTracking, current.date == date else { return }
        applyMeals(current.meals.filter { $0.scanId != scanId }, to: current)
    }

    private func restoreMeal(_ meal: CalorieMeal, originalIndex: Int, in date: String) {
        guard let current = caloriesTracking, current.date == date else { return }
        var updatedMeals = current.meals
        if let index = updatedMeals.firstIndex(where: { $0.scanId == meal.scanId }) {
            updatedMeals[index] = meal
        } else {
            updatedMeals.insert(meal, at: min(originalIndex, updatedMeals.count))
        }
        applyMeals(updatedMeals, to: current)
    }

    private func applyMeals(_ meals: [CalorieMeal], to tracking: CaloriesTracking) {
        let updated = CaloriesTracking(
            id: tracking.id,
            date: tracking.date,
            targetWaterCnt: tracking.targetWaterCnt,
            waterCnt: tracking.waterCnt,
            stepsCnt: tracking.stepsCnt,
            stepsKcal: tracking.stepsKcal,
            exerciseKcal: tracking.exerciseKcal,
            exerciseMin: tracking.exerciseMin,
            totalMealKcal: meals.reduce(0) { $0 + $1.nutritionFacts.calories * $1.mealCnt },
            meals: meals
        )
        contentMutationGeneration += 1
        caloriesTracking = updated
        if let profileID {
            caloriesActivityStore.updateMealCalories(
                profileID: profileID,
                date: tracking.date,
                calories: updated.mealCalories
            )
        }
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

    private func sanitizeServerSteps(_ tracking: CaloriesTracking) -> CaloriesTracking {
        CaloriesTracking(
            id: tracking.id,
            date: tracking.date,
            targetWaterCnt: tracking.targetWaterCnt,
            waterCnt: tracking.waterCnt,
            stepsCnt: 0,
            stepsKcal: 0,
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
    private(set) var lastError: String?

    var isSyncing: Bool {
        !syncingStepDates.isEmpty || !syncingExerciseDates.isEmpty
    }

    private let caloriesActivityStore: CaloriesActivityStore
    private let profileStore: UserProfileStore
    private let getCaloriesTrackingByDateUseCase: GetCaloriesTrackingByDateUseCaseProtocol
    private let updateWaterUseCase: UpdateWaterUseCaseProtocol
    private let fetchHistoryUseCase: FetchStepsHistoryUseCaseProtocol
    private var syncingStepDates: Set<String> = []
    private var syncingExerciseDates: Set<String> = []

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

    func synchronizePendingDates(before currentDate: String = CaloriesTracking.todayString) async {
        lastError = nil
        if let profileID = profileStore.currentProfile?.id {
            caloriesActivityStore.registerActiveDate(profileID: profileID, date: currentDate)
            caloriesActivityStore.cleanupReceiptBackedDrafts(profileID: profileID)
        }
        await synchronizePendingExercises(through: currentDate)
        await synchronizeCompletedSteps(before: currentDate)
        if let profileID = profileStore.currentProfile?.id {
            caloriesActivityStore.removeFullySyncedDrafts(
                profileID: profileID,
                before: currentDate
            )
        }
    }

    @discardableResult
    func synchronizeExercise(date: String, currentDate: String) async -> Bool {
        guard let profile = profileStore.currentProfile,
              let draft = caloriesActivityStore.draft(profileID: profile.id, date: date),
              draft.needsExerciseSync else { return true }
        guard !syncingExerciseDates.contains(date) else { return false }

        syncingExerciseDates.insert(date)
        defer { syncingExerciseDates.remove(date) }

        do {
            let tracking = try await getCaloriesTrackingByDateUseCase.execute(date: date)
            guard tracking.date == date else { throw NetworkError.decodingFailed }
            let normalizedDraft = caloriesActivityStore.seedIfNeeded(profileID: profile.id, tracking: tracking)
            try await updateWaterUseCase.execute(
                date: date,
                targetWaterCnt: nil,
                waterCnt: nil,
                stepsCnt: nil,
                stepsKcal: nil,
                exerciseKcal: normalizedDraft.exerciseKcal,
                exerciseMin: normalizedDraft.exerciseMin
            )
            caloriesActivityStore.markExerciseSynced(
                profileID: profile.id,
                date: date,
                expectedCalories: normalizedDraft.exerciseKcal,
                expectedSeconds: normalizedDraft.exerciseSeconds
            )
            if date < currentDate {
                caloriesActivityStore.removeIfFullySynced(profileID: profile.id, date: date)
            }
            return caloriesActivityStore.draft(profileID: profile.id, date: date)?.needsExerciseSync != true
        } catch {
            lastError = error.localizedDescription
            return false
        }
    }

    private func synchronizePendingExercises(through currentDate: String) async {
        guard let profile = profileStore.currentProfile else { return }
        let pending = caloriesActivityStore.pendingExerciseDrafts(
            profileID: profile.id,
            through: currentDate
        )
        for draft in pending {
            _ = await synchronizeExercise(date: draft.date, currentDate: currentDate)
        }
    }

    private func synchronizeCompletedSteps(before currentDate: String) async {
        guard let profile = profileStore.currentProfile else { return }

        let pendingDates = caloriesActivityStore.pendingFinalSyncDates(
            profileID: profile.id,
            before: currentDate
        )

        for date in pendingDates {
            guard !syncingStepDates.contains(date) else { continue }
            guard !caloriesActivityStore.hasSyncedSteps(profileID: profile.id, date: date) else {
                caloriesActivityStore.markStepSynced(profileID: profile.id, date: date)
                caloriesActivityStore.removeIfFullySynced(profileID: profile.id, date: date)
                continue
            }
            syncingStepDates.insert(date)
            do {
                guard let steps = try await refreshedSteps(for: date) else {
                    syncingStepDates.remove(date)
                    continue
                }
                let tracking = try await getCaloriesTrackingByDateUseCase.execute(date: date)
                guard tracking.date == date else { throw NetworkError.decodingFailed }
                let normalizedDraft = caloriesActivityStore.seedIfNeeded(
                    profileID: profile.id,
                    tracking: tracking
                )
                let stepCalories = StepAnalyticsCalculator(
                    weightKg: profile.weightKg ?? 70,
                    heightCm: profile.heightCm ?? 170
                ).caloriesBurned(steps: steps)

                try await updateWaterUseCase.execute(
                    date: date,
                    targetWaterCnt: tracking.targetWaterCnt > 0 ? tracking.targetWaterCnt : 8,
                    waterCnt: tracking.waterCnt,
                    stepsCnt: steps,
                    stepsKcal: Double(stepCalories),
                    exerciseKcal: normalizedDraft.exerciseKcal,
                    exerciseMin: normalizedDraft.exerciseMin
                )
                caloriesActivityStore.markStepSynced(profileID: profile.id, date: date)
                caloriesActivityStore.markExerciseSynced(
                    profileID: profile.id,
                    date: date,
                    expectedCalories: normalizedDraft.exerciseKcal,
                    expectedSeconds: normalizedDraft.exerciseSeconds
                )
                caloriesActivityStore.removeIfFullySynced(
                    profileID: profile.id,
                    date: date
                )
            } catch {
                lastError = error.localizedDescription
            }
            syncingStepDates.remove(date)
        }
    }

    private func refreshedSteps(for dateString: String) async throws -> Int? {
        guard let date = CaloriesTracking.date(from: dateString) else { return nil }
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start
        return try await fetchHistoryUseCase.executeCount(from: start, to: end)
    }
}
