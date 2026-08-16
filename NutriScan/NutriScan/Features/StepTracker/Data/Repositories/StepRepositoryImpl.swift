//
//  StepRepositoryImpl.swift
//  StepTracker - Data / Repositories
//

import Foundation

final class StepRepositoryImpl: StepRepositoryProtocol {
    private let healthKitSource: HealthKitStepDataSource

    init(
        healthKitSource: HealthKitStepDataSource = HealthKitStepDataSource()
    ) {
        self.healthKitSource = healthKitSource
    }

    func requestAuthorization() async throws -> Bool {
        try await healthKitSource.requestAuthorization()
    }

    func observeLiveSteps(from startOfDay: Date) -> AsyncStream<Int> {
        healthKitSource.observeSteps(from: startOfDay)
    }

    func fetchSteps(for date: Date) async throws -> DailySteps {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        let end = min(calendar.date(byAdding: .day, value: 1, to: start) ?? Date(), Date())
        let count = try await healthKitSource.fetchStepCount(from: start, to: end) ?? 0
        return DailySteps(date: start, stepCount: count)
    }

    func fetchStepCount(from startDate: Date, to endDate: Date) async throws -> Int? {
        try await healthKitSource.fetchStepCount(from: startDate, to: endDate)
    }

    func fetchStepsHistory(for range: StepHistoryRange) async throws -> [DailySteps] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -range.daysBack, to: endDate) ?? endDate
        return try await healthKitSource.fetchDailySteps(from: startDate, to: endDate)
    }

    func fetchStepsHistory(from startDate: Date, to endDate: Date) async throws -> [DailySteps] {
        return try await healthKitSource.fetchDailySteps(from: startDate, to: endDate)
    }
}
