//
//  UpdateFamilyMembersUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

protocol UpdateFamilyMembersUseCaseProtocol {
    func execute(members: [FamilyMemberInput]) async throws
}

struct UpdateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol {
    private let repository: UserProfileRepositoryProtocol
    
    init(repository: UserProfileRepositoryProtocol = DIContainer.shared.resolve(type: UserProfileRepositoryProtocol.self)) {
        self.repository = repository
    }
    
    func execute(members: [FamilyMemberInput]) async throws {
        try await repository.updateFamilyMembers(members)
    }
}
