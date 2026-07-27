//
//  HealthKitStepDataSource.swift
//  NutriScan
//
//  Created by Osama Hosam on 21/07/2026.
//


import Foundation
import HealthKit

final class HealthKitStepDataSource {
    private let healthStore = HKHealthStore()
    private let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestAuthorization() async throws -> Bool {
        guard isAvailable else { return false }
        try await healthStore.requestAuthorization(toShare: [], read: [stepType])
        return true
    }

    func fetchDailySteps(from startDate: Date, to endDate: Date) async throws -> [DailySteps] {
        let calendar = Calendar.current
        let interval = DateComponents(day: 1)
        let anchorDate = calendar.startOfDay(for: startDate)

        let query = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: interval
        )

        return try await withCheckedThrowingContinuation { continuation in
            query.initialResultsHandler = { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                var days: [DailySteps] = []
                results?.enumerateStatistics(from: startDate, to: endDate) { stats, _ in
                    let count = stats.sumQuantity()?.doubleValue(for: .count()) ?? 0
                    days.append(DailySteps(date: stats.startDate, stepCount: Int(count)))
                }
                continuation.resume(returning: days)
            }
            healthStore.execute(query)
        }
    }
}