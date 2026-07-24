//
//  PedometerDataSource.swift
//  StepTracker - Data / DataSources
//
//  The ONLY file in this feature that imports CoreMotion.
//  Everything above the Data layer stays framework-agnostic.
//

import CoreMotion
import Foundation

final class PedometerDataSource {
    private let pedometer = CMPedometer()

    var isStepCountingAvailable: Bool {
        CMPedometer.isStepCountingAvailable()
    }

    /// CMPedometer has no explicit "request auth" API — the system
    /// permission prompt appears the first time you query/start updates.
    /// We trigger that here with a harmless 1-minute historical query.
    func requestAuthorization() async throws -> Bool {
        guard CMPedometer.isStepCountingAvailable() else { return false }
        return try await withCheckedThrowingContinuation { continuation in
            let now = Date()
            pedometer.queryPedometerData(from: now.addingTimeInterval(-60), to: now) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: true)
                }
            }
        }
    }

    /// Starts live updates; `onUpdate` fires on every new pedometer event.
    func startLiveUpdates(from startDate: Date, onUpdate: @escaping (Int) -> Void) {
        guard CMPedometer.isStepCountingAvailable() else { return }
        pedometer.startUpdates(from: startDate) { data, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                onUpdate(data.numberOfSteps.intValue)
            }
        }
    }

    func stopUpdates() {
        pedometer.stopUpdates()
    }

    /// One-shot historical query, e.g. for "today so far" or past days.
    func fetchSteps(from startDate: Date, to endDate: Date) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            pedometer.queryPedometerData(from: startDate, to: endDate) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: data?.numberOfSteps.intValue ?? 0)
                }
            }
        }
    }
}
