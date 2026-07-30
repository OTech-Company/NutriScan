//
//  DailyTrackingService.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

protocol DailyTrackingService {
    func fetchToday() async throws -> DailyTrackingDTO
    func fetchByDate(date: String) async throws -> DailyTrackingDTO
    func fetchAll(page: Int, size: Int) async throws -> DailyTrackingPageDTO
    func addMeal(date: String, request: AddMealRequestDTO) async throws -> MealDTO
    func updateMeal(date: String, scanId: String, request: UpdateMealCountRequestDTO) async throws -> MealDTO
    func deleteMeal(date: String, scanId: String) async throws
    func patchTracking(date: String, body: PatchDailyTrackingDTO) async throws -> DailyTrackingDTO
    func deleteTracking(date: String) async throws
}

final class DailyTrackingServiceImpl: DailyTrackingService {

    func fetchToday() async throws -> DailyTrackingDTO {
        try await NetworkService.shared.request(DailyTrackingEndPoint.getToday)
    }

    func fetchByDate(date: String) async throws -> DailyTrackingDTO {
        try await NetworkService.shared.request(DailyTrackingEndPoint.getByDate(date: date))
    }

    func fetchAll(page: Int, size: Int) async throws -> DailyTrackingPageDTO {
        try await NetworkService.shared.request(DailyTrackingEndPoint.getAll(page: page, size: size))
    }

    func addMeal(date: String, request: AddMealRequestDTO) async throws -> MealDTO {
        try await NetworkService.shared.request(DailyTrackingEndPoint.addMeal(date: date, request: request))
    }

    func updateMeal(date: String, scanId: String, request: UpdateMealCountRequestDTO) async throws -> MealDTO {
        try await NetworkService.shared.request(DailyTrackingEndPoint.updateMeal(date: date, scanId: scanId, request: request))
    }

    func deleteMeal(date: String, scanId: String) async throws {
        let _: EmptyResponse = try await NetworkService.shared.request(DailyTrackingEndPoint.deleteMeal(date: date, scanId: scanId))
    }

    func patchTracking(date: String, body: PatchDailyTrackingDTO) async throws -> DailyTrackingDTO {
        try await NetworkService.shared.request(DailyTrackingEndPoint.patchTracking(date: date, body: body))
    }

    func deleteTracking(date: String) async throws {
        let _: EmptyResponse = try await NetworkService.shared.request(DailyTrackingEndPoint.deleteTracking(date: date))
    }
}
