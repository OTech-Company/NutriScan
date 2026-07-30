//
//  CaloriesTrackingService.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

protocol CaloriesTrackingService {
    func fetchToday() async throws -> CaloriesTrackingDTO
    func fetchByDate(date: String) async throws -> CaloriesTrackingDTO
    func fetchAll(page: Int, size: Int) async throws -> CaloriesTrackingPageDTO
    func addMeal(date: String, request: AddMealRequestDTO) async throws -> CalorieMealsDTO
    func updateMeal(date: String, scanId: String, request: UpdateMealCountRequestDTO) async throws -> CalorieMealsDTO
    func deleteMeal(date: String, scanId: String) async throws
    func patchTracking(date: String, body: PatchCaloriesTrackingDTO) async throws
    func deleteTracking(date: String) async throws
}

final class CaloriesTrackingServiceImpl: CaloriesTrackingService {

    func fetchToday() async throws -> CaloriesTrackingDTO {
        try await NetworkService.shared.request(CaloriesTrackingEndPoint.getToday)
    }

    func fetchByDate(date: String) async throws -> CaloriesTrackingDTO {
        try await NetworkService.shared.request(CaloriesTrackingEndPoint.getByDate(date: date))
    }

    func fetchAll(page: Int, size: Int) async throws -> CaloriesTrackingPageDTO {
        try await NetworkService.shared.request(CaloriesTrackingEndPoint.getAll(page: page, size: size))
    }

    func addMeal(date: String, request: AddMealRequestDTO) async throws -> CalorieMealsDTO {
        try await NetworkService.shared.request(CaloriesTrackingEndPoint.addMeal(date: date, request: request))
    }

    func updateMeal(date: String, scanId: String, request: UpdateMealCountRequestDTO) async throws -> CalorieMealsDTO {
        try await NetworkService.shared.request(CaloriesTrackingEndPoint.updateMeal(date: date, scanId: scanId, request: request))
    }

    func deleteMeal(date: String, scanId: String) async throws {
        let _: EmptyResponse = try await NetworkService.shared.request(CaloriesTrackingEndPoint.deleteMeal(date: date, scanId: scanId))
    }

    func patchTracking(date: String, body: PatchCaloriesTrackingDTO) async throws {
        let _: EmptyResponse = try await NetworkService.shared.request(
            CaloriesTrackingEndPoint.patchTracking(date: date, body: body)
        )
    }

    func deleteTracking(date: String) async throws {
        let _: EmptyResponse = try await NetworkService.shared.request(CaloriesTrackingEndPoint.deleteTracking(date: date))
    }
}
