//
//  UpdateProfileUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

protocol UpdateProfileUseCaseProtocol {
    func execute(update: ProfileUpdate) async throws
}

struct UpdateProfileUseCase: UpdateProfileUseCaseProtocol {
    private let repository: UserProfileRepositoryProtocol
    
    init(repository: UserProfileRepositoryProtocol = DIContainer.shared.resolve(type: UserProfileRepositoryProtocol.self)) {
        self.repository = repository
    }
    
    func execute(update: ProfileUpdate) async throws {
        try await repository.updateProfile(update: update)
    }
}
