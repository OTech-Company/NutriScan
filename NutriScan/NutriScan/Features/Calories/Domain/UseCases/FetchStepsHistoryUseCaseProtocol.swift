//
//  FetchStepsHistoryUseCaseProtocol.swift
//  NutriScan
//
//  Created by Osama Hosam on 21/07/2026.
//


import Foundation

protocol FetchStepsHistoryUseCaseProtocol {
    func execute(range: StepHistoryRange) async throws -> [DailySteps]
}

final class FetchStepsHistoryUseCase: FetchStepsHistoryUseCaseProtocol {
    private let repository: StepRepositoryProtocol

    init(repository: StepRepositoryProtocol) {
        self.repository = repository
    }

    func execute(range: StepHistoryRange) async throws -> [DailySteps] {
        try await repository.fetchStepsHistory(for: range)
    }
}