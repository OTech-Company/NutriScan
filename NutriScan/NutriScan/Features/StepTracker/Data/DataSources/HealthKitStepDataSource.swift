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

    func observeSteps(from startDate: Date) -> AsyncStream<Int> {
        AsyncStream { continuation in
            guard isAvailable else {
                continuation.finish()
                return
            }
            let observation = HealthKitLiveStepObservation(
                healthStore: healthStore,
                stepType: stepType,
                startDate: startDate,
                continuation: continuation
            )
            continuation.onTermination = { [weak observation] _ in
                observation?.stop()
            }
            observation.start()
        }
    }

    func fetchStepCount(from startDate: Date, to endDate: Date) async throws -> Int? {
        guard isAvailable, endDate > startDate else { return nil }
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: [.strictStartDate, .strictEndDate]
        )
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, statistics, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let quantity = statistics?.sumQuantity() else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: Int(quantity.doubleValue(for: .count())))
            }
            healthStore.execute(query)
        }
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
                    guard let quantity = stats.sumQuantity() else { return }
                    let count = quantity.doubleValue(for: .count())
                    days.append(DailySteps(date: stats.startDate, stepCount: Int(count)))
                }
                continuation.resume(returning: days)
            }
            healthStore.execute(query)
        }
    }

    func enableBackgroundStepMonitoring(scheduler: SmartNotificationSchedulerProtocol) {
        guard isAvailable else { return }
        healthStore.enableBackgroundDelivery(for: stepType, frequency: .immediate) { _, _ in }

        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { [weak self] _, completionHandler, error in
            guard let self = self, error == nil else {
                completionHandler()
                return
            }
            Task {
                let now = Date()
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: now)
                if let days = try? await self.fetchDailySteps(from: startOfDay, to: now),
                   let todaySteps = days.first?.stepCount {
                    let hour = calendar.component(.hour, from: now)
                    if hour < 16 && todaySteps >= 4000 {
                        await scheduler.cancelAfternoonStepsMove()
                    }
                }
                completionHandler()
            }
        }
        healthStore.execute(query)
    }
}

private final class HealthKitLiveStepObservation: @unchecked Sendable {
    private let healthStore: HKHealthStore
    private let stepType: HKQuantityType
    private let startDate: Date
    private let continuation: AsyncStream<Int>.Continuation
    private let lock = NSLock()

    private var observerQuery: HKObserverQuery?
    private var statisticsQuery: HKStatisticsQuery?
    private var isRefreshRunning = false
    private var needsAnotherRefresh = false
    private var isStopped = false

    init(
        healthStore: HKHealthStore,
        stepType: HKQuantityType,
        startDate: Date,
        continuation: AsyncStream<Int>.Continuation
    ) {
        self.healthStore = healthStore
        self.stepType = stepType
        self.startDate = startDate
        self.continuation = continuation
    }

    func start() {
        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { [self] _, completion, error in
            defer { completion() }
            guard error == nil else { return }
            refresh()
        }

        lock.lock()
        guard !isStopped else {
            lock.unlock()
            return
        }
        observerQuery = query
        lock.unlock()

        healthStore.execute(query)
        refresh()
    }

    func stop() {
        lock.lock()
        guard !isStopped else {
            lock.unlock()
            return
        }
        isStopped = true
        let observer = observerQuery
        let statistics = statisticsQuery
        observerQuery = nil
        statisticsQuery = nil
        needsAnotherRefresh = false
        lock.unlock()

        if let observer { healthStore.stop(observer) }
        if let statistics { healthStore.stop(statistics) }
    }

    private func refresh() {
        lock.lock()
        guard !isStopped else {
            lock.unlock()
            return
        }
        if isRefreshRunning {
            needsAnotherRefresh = true
            lock.unlock()
            return
        }
        isRefreshRunning = true
        lock.unlock()

        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: Date(),
            options: [.strictStartDate, .strictEndDate]
        )
        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { [self] _, statistics, _ in
            finishRefresh(quantity: statistics?.sumQuantity())
        }

        lock.lock()
        let shouldExecute = !isStopped
        if shouldExecute { statisticsQuery = query }
        lock.unlock()

        if shouldExecute {
            healthStore.execute(query)
        } else {
            healthStore.stop(query)
        }
    }

    private func finishRefresh(quantity: HKQuantity?) {
        lock.lock()
        let shouldYield = !isStopped
        statisticsQuery = nil
        isRefreshRunning = false
        let shouldRefreshAgain = needsAnotherRefresh && !isStopped
        needsAnotherRefresh = false
        lock.unlock()

        if shouldYield, let quantity {
            continuation.yield(Int(quantity.doubleValue(for: .count())))
        }
        if shouldRefreshAgain { refresh() }
    }
}
