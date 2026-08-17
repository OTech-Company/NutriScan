//
//  FetchStepsHistoryUseCaseProtocol.swift
//  NutriScan
//
//  Created by Osama Hosam on 21/07/2026.
//


import Foundation

protocol FetchStepsHistoryUseCaseProtocol {
    func execute(range: StepHistoryRange) async throws -> [DailySteps]
    func execute(from startDate: Date, to endDate: Date) async throws -> [DailySteps]
    func executeCount(from startDate: Date, to endDate: Date) async throws -> Int?
}

final class FetchStepsHistoryUseCase: FetchStepsHistoryUseCaseProtocol {
    private let repository: StepRepositoryProtocol

    init(repository: StepRepositoryProtocol) {
        self.repository = repository
    }

    func execute(range: StepHistoryRange) async throws -> [DailySteps] {
        try await repository.fetchStepsHistory(for: range)
    }

    func execute(from startDate: Date, to endDate: Date) async throws -> [DailySteps] {
        try await repository.fetchStepsHistory(from: startDate, to: endDate)
    }

    func executeCount(from startDate: Date, to endDate: Date) async throws -> Int? {
        try await repository.fetchStepCount(from: startDate, to: endDate)
    }
}
