//
//  DailyTrackingRemoteDataSource.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 30/07/2026.
//

import Foundation

protocol DailyTrackingRemoteDataSourceProtocol {
    /// Attempts to add a new meal entry. Throws if the network call fails.
    func addMeal(date: String, scanId: String, mealCnt: Int) async throws -> DailyTrackingMealDTO
    /// Updates the meal count for an existing entry.
    func updateMeal(date: String, scanId: String, mealCnt: Int) async throws -> DailyTrackingMealDTO
}

final class DailyTrackingRemoteDataSource: DailyTrackingRemoteDataSourceProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func addMeal(date: String, scanId: String, mealCnt: Int) async throws -> DailyTrackingMealDTO {
        let endpoint = DailyTrackingEndpoint.addMeal(date: date, scanId: scanId, mealCnt: mealCnt)
        return try await networkService.request(endpoint)
    }

    func updateMeal(date: String, scanId: String, mealCnt: Int) async throws -> DailyTrackingMealDTO {
        let endpoint = DailyTrackingEndpoint.updateMeal(date: date, scanId: scanId, mealCnt: mealCnt)
        return try await networkService.request(endpoint)
    }
}
