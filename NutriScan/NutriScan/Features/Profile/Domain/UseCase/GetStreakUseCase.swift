//
//  GetStreakUseCase.swift
//  NutriScan
//

import Foundation

// MARK: - Protocol

protocol GetStreakUseCaseProtocol {
    func execute() async throws -> Int
}

// MARK: - Implementation

final class GetStreakUseCase: GetStreakUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol = DIContainer.shared.resolve(type: ProfileRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute() async throws -> Int {
        try await repository.getStreak()
    }
}
