//
//  GetProfileDataUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

final class GetEditProfileUseCase: GetEditProfileUseCaseProtocol {
    private let repository: EditProfileRepositoryProtocol

    init(repository: EditProfileRepositoryProtocol = DIContainer.shared.resolve(type: EditProfileRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute() async throws -> (profile: Profile, allergies: [ReferenceItem], diseases: [ReferenceItem]) {
        // Concurrently execute all three network requests
        async let profileTask = repository.getProfile()
        async let allergiesTask = repository.getAllergies()
        async let diseasesTask = repository.getDiseases()

        let (profile, allergies, diseases) = try await (profileTask, allergiesTask, diseasesTask)

        return (profile, allergies, diseases)
    }
}
