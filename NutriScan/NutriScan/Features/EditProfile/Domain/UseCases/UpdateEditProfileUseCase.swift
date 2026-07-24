//
//  UpdateProfileUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

final class UpdateEditProfileUseCase: UpdateEditProfileUseCaseProtocol {
    private let repository: EditProfileRepositoryProtocol

    init(repository: EditProfileRepositoryProtocol = DIContainer.shared.resolve(type: EditProfileRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute(update: ProfileUpdate) async throws -> Profile {
        // Here you could add additional domain-level business validation before hitting the repository if needed
        return try await repository.updateProfile(update: update)
    }
}
