//
//  StepRepositoryImpl.swift
//  StepTracker - Data / Repositories
//

import Foundation

final class StepRepositoryImpl: StepRepositoryProtocol {
    private let pedometerSource: PedometerDataSource
    private let healthKitSource: HealthKitStepDataSource

    init(
        pedometerSource: PedometerDataSource = PedometerDataSource(),
        healthKitSource: HealthKitStepDataSource = HealthKitStepDataSource()
    ) {
        self.pedometerSource = pedometerSource
        self.healthKitSource = healthKitSource
    }

    func requestAuthorization() async throws -> Bool {
        // Both sources need permission; live counting needs Motion & Fitness,
        // history needs HealthKit read access.
        let pedometerGranted = try await pedometerSource.requestAuthorization()
        let healthKitGranted = try await healthKitSource.requestAuthorization()
        return pedometerGranted && healthKitGranted
    }

    func observeLiveSteps(from startOfDay: Date) -> AsyncStream<Int> {
        AsyncStream { continuation in
            pedometerSource.startLiveUpdates(from: startOfDay) { steps in
                continuation.yield(steps)
            }
            continuation.onTermination = { [weak pedometerSource] _ in
                pedometerSource?.stopUpdates()
            }
        }
    }

    func fetchSteps(for date: Date) async throws -> DailySteps {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? Date()
        let count = try await pedometerSource.fetchSteps(from: start, to: min(end, Date()))
        return DailySteps(date: start, stepCount: count)
    }

    func fetchStepsHistory(for range: StepHistoryRange) async throws -> [DailySteps] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -range.daysBack, to: endDate) ?? endDate
        return try await healthKitSource.fetchDailySteps(from: startDate, to: endDate)
    }
}
