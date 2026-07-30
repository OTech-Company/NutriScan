//
//  DailyTrackingRepoImpl.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

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
