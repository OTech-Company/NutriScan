//
//  StepRepositoryProtocol.swift
//  StepTracker - Domain / Repositories
//

import Foundation

/// Predefined ranges the UI can request history for.
enum StepHistoryRange {
    case sinceYesterday
    case lastWeek
    case lastMonth
    case last3Months
    case last6Months

    /// Number of days to look back from today (inclusive of today).
    var daysBack: Int {
        switch self {
        case .sinceYesterday: return 2
        case .lastWeek: return 7
        case .lastMonth: return 30
        case .last3Months: return 90
        case .last6Months: return 180
        }
    }
}

/// Domain-level contract. The Presentation layer (via UseCases) only ever
/// depends on this protocol, never on the concrete Data-layer implementation.
protocol StepRepositoryProtocol {
    /// Requests permission to read motion/step data.
    func requestAuthorization() async throws -> Bool

    /// Emits a live stream of the running step count since `startOfDay`.
    func observeLiveSteps(from startOfDay: Date) -> AsyncStream<Int>

    /// One-shot fetch of the total steps for a given calendar day.
    func fetchSteps(for date: Date) async throws -> DailySteps

    /// One-shot fetch of a per-day step history for the given range.
    func fetchStepsHistory(for range: StepHistoryRange) async throws -> [DailySteps]
}
