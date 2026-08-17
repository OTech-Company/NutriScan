//
//  DailyTrackingRepository.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 30/07/2026.
//

import Foundation

final class DailyTrackingRepository: DailyTrackingRepositoryProtocol {

    private let remoteDataSource: DailyTrackingRemoteDataSourceProtocol
    private let dayProvider: DailyTrackingDayProviding

    init(
        remoteDataSource: DailyTrackingRemoteDataSourceProtocol = DailyTrackingRemoteDataSource(),
        dayProvider: DailyTrackingDayProviding = ServerDailyTrackingDayProvider()
    ) {
        self.remoteDataSource = remoteDataSource
        self.dayProvider = dayProvider
    }

    /// Fetches today's daily tracking data to check if the product already exists.
    /// If it exists, uses PUT to increment its `mealCnt` by 1.
    /// If it does not exist, uses POST to add it with `mealCnt` = 1.
    func addOrIncrementMeal(scanId: String) async throws {
        // 1. Let the backend create or return its authoritative current record.
        let todayData = try await remoteDataSource.getToday()
        guard let today = todayData.date,
              dayProvider.date(from: today) != nil else {
            throw NetworkError.decodingFailed
        }

        // 2. Check if the product already exists in today's meals
        if let existingMeal = todayData.meals?.first(where: { $0.scanId == scanId }) {
            // 3a. Product exists -> Increment the counter and PUT
            let newCount = existingMeal.mealCnt + 1
            _ = try await remoteDataSource.updateMeal(date: today, scanId: scanId, mealCnt: newCount)
        } else {
            // 3b. Product doesn't exist -> POST with counter = 1
            _ = try await remoteDataSource.addMeal(date: today, scanId: scanId, mealCnt: 1)
        }
    }

}
