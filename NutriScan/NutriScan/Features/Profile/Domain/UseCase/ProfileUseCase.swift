//
//  ProfileUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

final class ProfileUseCase: ProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol = DIContainer.shared.resolve(type: ProfileRepositoryProtocol.self)) {
            self.repository = repository
        }

    func getEditProfileData() async throws -> (profile: Profile, allergies: [ReferenceItem], diseases: [ReferenceItem]) {
        // Concurrently execute all three network requests
        async let profileTask = repository.getProfile()
        async let allergiesTask = repository.getAllergies()
        async let diseasesTask = repository.getDiseases()
        
        let (profile, allergies, diseases) = try await (profileTask, allergiesTask, diseasesTask)
        
        return (profile, allergies, diseases)
    }

    func updateProfile(update: ProfileUpdate) async throws -> Profile {
        // Here you could add additional domain-level business validation before hitting the repository if needed
        return try await repository.updateProfile(update: update)
    }
}
