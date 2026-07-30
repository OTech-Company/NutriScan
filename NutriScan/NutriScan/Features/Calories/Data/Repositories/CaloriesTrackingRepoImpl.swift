//
//  CaloriesTrackingRepoImpl.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

final class CaloriesTrackingRepoImpl: CaloriesTrackingRepo {

    private let service: CaloriesTrackingService

    init(service: CaloriesTrackingService) {
        self.service = service
    }

    func getTodayCaloriesTracking() async throws -> CaloriesTracking {
        CaloriesTracking(from: try await service.fetchToday())
    }

    func getCaloriesTrackingByDate(date: String) async throws -> CaloriesTracking {
        CaloriesTracking(from: try await service.fetchByDate(date: date))
    }

    func getAllCaloriesTracking(page: Int, size: Int) async throws -> (items: [CaloriesTrackingSummary], totalPages: Int) {
        let page = try await service.fetchAll(page: page, size: size)
        let items = (page.content ?? []).map { CaloriesTrackingSummary(from: $0) }
        return (items, page.totalPages ?? 0)
    }

    func addMeal(date: String, scanId: String, mealCnt: Int) async throws -> CalorieMeal {
        let request = AddMealRequestDTO(scanId: scanId, mealCnt: mealCnt)
        let result = try await service.addMeal(date: date, request: request)
        return CalorieMeal(from: result)
    }

    func updateMealCount(date: String, scanId: String, mealCnt: Int) async throws -> CalorieMeal {
        let request = UpdateMealCountRequestDTO(mealCnt: mealCnt)
        let result = try await service.updateMeal(date: date, scanId: scanId, request: request)
        return CalorieMeal(from: result)
    }

    func deleteMeal(date: String, scanId: String) async throws {
        try await service.deleteMeal(date: date, scanId: scanId)
    }

    func updateCaloriesTracking(
        date: String,
        targetWaterCnt: Int?,
        waterCnt: Int?,
        stepsCnt: Int?,
        stepsKcal: Int?,
        exerciseKcal: Int?,
        exerciseMin: Double?,
        totalMealKcal: Int?
    ) async throws -> CaloriesTracking {
        let body = PatchCaloriesTrackingDTO(
            date: date,
            targetWaterCnt: targetWaterCnt,
            waterCnt: waterCnt,
            stepsCnt: stepsCnt,
            stepsKcal: stepsKcal,
            exerciseKcal: exerciseKcal,
            exerciseMin: exerciseMin,
            totalMealKcal: totalMealKcal
        )
        try await service.patchTracking(date: date, body: body)
        return CaloriesTracking(from: try await service.fetchByDate(date: date))
    }

    func deleteTracking(date: String) async throws {
        try await service.deleteTracking(date: date)
    }
}
