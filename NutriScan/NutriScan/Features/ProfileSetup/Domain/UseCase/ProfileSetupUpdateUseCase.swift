//
//  ProfileSetupUpdateUseCase.swift
//  NutriScan
//

import Foundation

protocol ProfileSetupUpdateUseCaseProtocol {
    func execute(_ update: ProfileSetupUpdate) async throws -> ProfileSetupUserProfile
}

final class ProfileSetupUpdateUseCase: ProfileSetupUpdateUseCaseProtocol {
    private let repository: ProfileSetupRepositoryProtocol
    
    init(repository: ProfileSetupRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ update: ProfileSetupUpdate) async throws -> ProfileSetupUserProfile {
        try await repository.updateProfile(update)
    }
}
