//
//  DailyTrackingRepository.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 30/07/2026.
//

import Foundation

final class DailyTrackingRepository: DailyTrackingRepositoryProtocol {

    private let remoteDataSource: DailyTrackingRemoteDataSourceProtocol

    init(remoteDataSource: DailyTrackingRemoteDataSourceProtocol = DailyTrackingRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    /// Tries POST first. If the server returns a conflict (409) or a server error
    /// indicating the product already exists, falls back to PUT with mealCnt + 1.
    func addOrIncrementMeal(scanId: String) async throws {
        let today = Self.todayDateString()

        do {
            // Attempt to add as a new meal entry (mealCnt = 1 for a first-time add)
            _ = try await remoteDataSource.addMeal(date: today, scanId: scanId, mealCnt: 1)
        } catch let networkError as NetworkError {
            switch networkError {
            case .serverError(let statusCode) where statusCode == 409:
                // Product already exists in today's meals → increment by 1
                _ = try await remoteDataSource.updateMeal(date: today, scanId: scanId, mealCnt: 1)
            case .apiError(let apiErrorResponse):
                // Some backends encode conflicts inside the body with a 4xx code.
                // Treat any duplicate/conflict message as an existing-product scenario.
                let msg = apiErrorResponse.message?.lowercased() ?? ""
                if msg.contains("exist") || msg.contains("duplicate") || msg.contains("conflict") {
                    _ = try await remoteDataSource.updateMeal(date: today, scanId: scanId, mealCnt: 1)
                } else {
                    throw networkError
                }
            default:
                throw networkError
            }
        }
    }

    // MARK: - Helpers

    private static func todayDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: Date())
    }
}
