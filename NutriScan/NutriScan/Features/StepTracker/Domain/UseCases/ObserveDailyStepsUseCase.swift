//
//  ObserveDailyStepsUseCase.swift
//  StepTracker - Domain / UseCases
//

import Foundation

protocol ObserveDailyStepsUseCaseProtocol {
    /// Returns a live stream of today's step count, starting from midnight.
    func execute() -> AsyncStream<Int>
}

final class ObserveDailyStepsUseCase: ObserveDailyStepsUseCaseProtocol {
    private let repository: StepRepositoryProtocol
    private let dayProvider: DailyTrackingDayProviding
    private let dateProvider: () -> Date

    init(
        repository: StepRepositoryProtocol,
        dayProvider: DailyTrackingDayProviding,
        dateProvider: @escaping () -> Date = Date.init
    ) {
        self.repository = repository
        self.dayProvider = dayProvider
        self.dateProvider = dateProvider
    }

    func execute() -> AsyncStream<Int> {
        let startOfDay = dayProvider.calendar.startOfDay(for: dateProvider())
        return repository.observeLiveSteps(from: startOfDay)
    }
}
