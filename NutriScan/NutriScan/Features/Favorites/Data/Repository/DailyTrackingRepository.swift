//
//  DailyTrackingRepository.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 30/07/2026.
//

import Foundation

final class DailyTrackingRepository: DailyTrackingRepositoryProtocol {

    private let remoteDataSource: DailyTrackingRemoteDataSourceProtocol
    private let dateProvider: () -> Date

    init(
        remoteDataSource: DailyTrackingRemoteDataSourceProtocol = DailyTrackingRemoteDataSource(),
        dateProvider: @escaping () -> Date = Date.init
    ) {
        self.remoteDataSource = remoteDataSource
        self.dateProvider = dateProvider
    }

    /// Fetches today's daily tracking data to check if the product already exists.
    /// If it exists, uses PUT to increment its `mealCnt` by 1.
    /// If it does not exist, uses POST to add it with `mealCnt` = 1.
    func addOrIncrementMeal(scanId: String) async throws {
        let today = Self.dateString(from: dateProvider())

        // 1. Fetch the exact device-local date's tracking data.
        let todayData = try await remoteDataSource.getByDate(date: today)

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

    // MARK: - Helpers

    private static func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = .current
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
}
