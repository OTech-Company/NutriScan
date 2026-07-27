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

    func addMeal(date: String, meal: Meal) async throws -> Meal {
        let dto = MealDTO(from: meal)
        let result = try await service.addMeal(date: date, meal: dto)
        return Meal(from: result)
    }

    func updateMeal(date: String, scanId: String, meal: Meal) async throws -> Meal {
        let dto = MealDTO(from: meal)
        let result = try await service.updateMeal(date: date, scanId: scanId, meal: dto)
        return Meal(from: result)
    }

    func deleteMeal(date: String, scanId: String) async throws {
        try await service.deleteMeal(date: date, scanId: scanId)
    }

    func updateWaterAndSteps(
        date: String,
        targetWaterCnt: Int?,
        waterCnt: Int?,
        stepsCnt: Int?
    ) async throws {
        let body = PatchDailyTrackingDTO(
            date: date,
            targetWaterCnt: targetWaterCnt,
            waterCnt: waterCnt,
            stepsCnt: stepsCnt
        )
        try await service.patchTracking(date: date, body: body)
    }

    func deleteTracking(date: String) async throws {
        try await service.deleteTracking(date: date)
    }
}
