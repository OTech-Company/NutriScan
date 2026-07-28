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
    private let repository: SharedProfileRepositoryProtocol
    
    init(repository: SharedProfileRepositoryProtocol = DIContainer.shared.resolve(type: SharedProfileRepositoryProtocol.self)) {
        self.repository = repository
    }
    
    func execute(members: [FamilyMemberInput]) async throws {
        try await repository.updateFamilyMembers(members)
    }
}
