//
//  UpdateStreakUseCase.swift
//  NutriScan
//

import Foundation

// MARK: - Protocol

protocol UpdateStreakUseCaseProtocol {
    func execute() async throws
}

// MARK: - Implementation

final class UpdateStreakUseCase: UpdateStreakUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol = DIContainer.shared.resolve(type: ProfileRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.updateStreak()
    }
}
