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

    var dailyKcal: Int   { dailyTracking?.totalCalories ?? 0 }
    var meals: [Meal]    { dailyTracking?.meals ?? [] }
    var waterCurrent: Int { dailyTracking?.waterCnt ?? 0 }
    var waterGoal: Int   { dailyTracking?.targetWaterCnt ?? 8 }

    var currentTdee: Float { Float(dailyTracking?.totalCalories ?? 0) }
    var maxTdee: Float = 2350

    var exerciseKcal: Int = 0
    var exerciseMinutes: Int = 0

    private let getTodayTrackingUseCase: GetTodayTrackingUseCase
    private let addMealUseCase: AddMealUseCase
    private let deleteMealUseCase: DeleteMealUseCase
    private let updateWaterUseCase: UpdateWaterUseCase

    init() {
        self.getTodayTrackingUseCase = DIContainer.shared.resolve(type: GetTodayTrackingUseCase.self)
        self.addMealUseCase          = DIContainer.shared.resolve(type: AddMealUseCase.self)
        self.deleteMealUseCase       = DIContainer.shared.resolve(type: DeleteMealUseCase.self)
        self.updateWaterUseCase      = DIContainer.shared.resolve(type: UpdateWaterUseCase.self)
    }

    func onAppear() {
        Task { await fetchTodayTracking() }
    }

    func fetchTodayTracking() async {
        isLoading = true
        errorMessage = nil
        do {
            dailyTracking = try await getTodayTrackingUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func fillCup(index: Int) {
        guard index < waterGoal else { return }
        let newWaterCnt = index + 1
        guard let current = dailyTracking, newWaterCnt > current.waterCnt else { return }
        updateLocalWater(newWaterCnt)
        Task { await syncWater(newWaterCnt) }
    }

    func unfillCup(index: Int) {
        guard index < waterGoal else { return }
        let newWaterCnt = index
        guard let current = dailyTracking, newWaterCnt < current.waterCnt else { return }
        updateLocalWater(newWaterCnt)
        Task { await syncWater(newWaterCnt) }
    }

    func addTargetCup() {
        guard let current = dailyTracking else { return }
        let newTarget = current.targetWaterCnt + 1
        updateLocalWaterTarget(newTarget)
        Task { await syncWaterTarget(newTarget, waterCnt: current.waterCnt) }
    }

    func removeTargetCup() {
        guard let current = dailyTracking, current.targetWaterCnt > 1 else { return }
        let newTarget = current.targetWaterCnt - 1
        let clampedWater = min(current.waterCnt, newTarget)
        updateLocalWaterTarget(newTarget, clampedWater: clampedWater)
        Task { await syncWaterTarget(newTarget, waterCnt: clampedWater) }
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

    private func updateLocalWater(_ count: Int) {
        guard let current = dailyTracking else { return }
        dailyTracking = DailyTracking(
            id: current.id, date: current.date,
            targetWaterCnt: current.targetWaterCnt,
            waterCnt: count,
            stepsCnt: current.stepsCnt, meals: current.meals
        )
    }

    private func updateLocalWaterTarget(_ target: Int, clampedWater: Int? = nil) {
        guard let current = dailyTracking else { return }
        dailyTracking = DailyTracking(
            id: current.id, date: current.date,
            targetWaterCnt: target,
            waterCnt: clampedWater ?? current.waterCnt,
            stepsCnt: current.stepsCnt, meals: current.meals
        )
    }

    private func syncWater(_ count: Int) async {
        guard let current = dailyTracking else { return }
        do {
            try await updateWaterUseCase.execute(date: current.date, waterCnt: count)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func syncWaterTarget(_ target: Int, waterCnt: Int) async {
        guard let current = dailyTracking else { return }
        do {
            try await updateWaterUseCase.execute(
                date: current.date,
                targetWaterCnt: target,
                waterCnt: waterCnt
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
