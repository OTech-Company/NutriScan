//
//  EditProfileAssembly.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//

import Foundation

struct EditProfileAssembly: Assembly {
    func assemble(container: DIContainer) {
        container.register(
            type: ProfileRemoteDataSourceProtocol.self,
            component: ProfileRemoteDataSource(
                networkService: container.resolve(type: NetworkServiceProtocol.self))
        )

        container.register(
            type: EditProfileRepositoryProtocol.self,
            component: EditProfileRepository(
                remoteDataSource: container.resolve(type: ProfileRemoteDataSourceProtocol.self))
        )

        container.register(
            type: GetEditProfileUseCaseProtocol.self,
            component: GetEditProfileUseCase(
                repository: container.resolve(type: EditProfileRepositoryProtocol.self))
        )

        container.register(
            type: UpdateEditProfileUseCaseProtocol.self,
            component: UpdateEditProfileUseCase(
                repository: container.resolve(type: EditProfileRepositoryProtocol.self))
        )
    }
}
