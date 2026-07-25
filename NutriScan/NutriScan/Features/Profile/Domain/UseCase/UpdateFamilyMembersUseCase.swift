//
//  UpdateFamilyMembersUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

final class UpdateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol {
    private let repository: ProfileSummaryRepositoryProtocol

    init(repository: ProfileSummaryRepositoryProtocol = DIContainer.shared.resolve(type: ProfileSummaryRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute(members: [FamilyMemberInput]) async throws -> ProfileSummary {
        try await repository.updateFamilyMembers(members)
    }
}
