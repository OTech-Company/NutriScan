//
//  GetProfileSummaryUseCase.swift
//  NutriScan
//

import Foundation

// MARK: - Protocol

protocol GetProfileSummaryUseCaseProtocol {
    func execute() async throws -> ProfileSummary
}

// MARK: - Implementation

final class GetProfileSummaryUseCase: GetProfileSummaryUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol = DIContainer.shared.resolve(type: ProfileRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute() async throws -> ProfileSummary {
        try await repository.getProfileSummary()
    }
}
