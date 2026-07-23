//
//  GetProfileDataUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

final class GetProfileDataUseCase: GetProfileDataUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol = DIContainer.shared.resolve(type: ProfileRepositoryProtocol.self)) {
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
