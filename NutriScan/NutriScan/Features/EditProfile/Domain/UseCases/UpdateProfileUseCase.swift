//
//  UpdateProfileUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

final class UpdateProfileUseCase: UpdateProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol = DIContainer.shared.resolve(type: ProfileRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute(update: ProfileUpdate) async throws -> Profile {
        // Here you could add additional domain-level business validation before hitting the repository if needed
        return try await repository.updateProfile(update: update)
    }
}
