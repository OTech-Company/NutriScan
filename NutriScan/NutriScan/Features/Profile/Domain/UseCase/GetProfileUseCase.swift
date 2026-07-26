//
//  GetProfileUseCase.swift
//  NutriScan
//

import Foundation

// MARK: - Protocol

protocol GetProfileUseCaseProtocol {
    func execute() async throws -> ProfileInfo
}

// MARK: - Implementation

final class GetProfileUseCase: GetProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol = DIContainer.shared.resolve(type: ProfileRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute() async throws -> ProfileInfo {
        try await repository.getProfile()
    }
}
