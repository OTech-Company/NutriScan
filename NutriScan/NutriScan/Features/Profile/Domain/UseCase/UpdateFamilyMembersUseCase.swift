//
//  UpdateFamilyMembersUseCase.swift
//  NutriScan
//

import Foundation

// MARK: - Protocol

protocol UpdateFamilyMembersUseCaseProtocol {
    func execute(members: [FamilyMemberInput]) async throws -> ProfileInfo
}

// MARK: - Implementation

final class UpdateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol = DIContainer.shared.resolve(type: ProfileRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute(members: [FamilyMemberInput]) async throws -> ProfileInfo {
        try await repository.updateFamilyMembers(members)
    }
}
