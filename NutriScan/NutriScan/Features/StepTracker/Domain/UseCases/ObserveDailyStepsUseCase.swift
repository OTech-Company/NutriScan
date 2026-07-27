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

    init(repository: StepRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AsyncStream<Int> {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        return repository.observeLiveSteps(from: startOfDay)
    }
}
