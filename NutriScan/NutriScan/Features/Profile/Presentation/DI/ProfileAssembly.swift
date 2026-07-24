//
//  ProfileAssembly.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

struct ProfileAssembly: Assembly {
    func assemble(container: DIContainer) {

        // 1. Register Remote Data Source
        container.register(
            type: ProfileRemoteDataSourceProtocol.self,
            component: ProfileRemoteDataSource(
                networkService: container.resolve(
                    type: NetworkServiceProtocol.self))
        )

        // 2. Register Repository (now depending on the Remote Data Source)
        container.register(
            type: EditProfileRepositoryProtocol.self,
            component: EditProfileRepository(
                remoteDataSource: container.resolve(
                    type: ProfileRemoteDataSourceProtocol.self))
        )

        // 3. Register Use Cases
        container.register(
            type: GetEditProfileUseCaseProtocol.self,
            component: GetEditProfileUseCase(
                repository: container.resolve(
                    type: EditProfileRepositoryProtocol.self))
        )

        container.register(
            type: UpdateEditProfileUseCaseProtocol.self,
            component: UpdateEditProfileUseCase(
                repository: container.resolve(
                    type: EditProfileRepositoryProtocol.self))
        )
        // Profile (new — full name + family members)
        container.register(
            type: ProfileSummaryRemoteDataSourceProtocol.self,
            component: ProfileSummaryRemoteDataSource(
                networkService: container.resolve(
                    type: NetworkServiceProtocol.self))
        )
        container.register(
            type: ProfileSummaryRepositoryProtocol.self,
            component: ProfileSummaryRepository(
                remoteDataSource: container.resolve(
                    type: ProfileSummaryRemoteDataSourceProtocol.self))
        )
        container.register(
            type: GetProfileSummaryUseCaseProtocol.self,
            component: GetProfileSummaryUseCase(
                repository: container.resolve(
                    type: ProfileSummaryRepositoryProtocol.self))
        )
        container.register(
            type: UpdateFamilyMembersUseCaseProtocol.self,
            component: UpdateFamilyMembersUseCase(
                repository: container.resolve(
                    type: ProfileSummaryRepositoryProtocol.self))
        )
    }
}
