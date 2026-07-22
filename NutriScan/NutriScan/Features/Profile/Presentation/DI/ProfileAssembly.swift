//
//  ProfileAssembly.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

struct ProfileAssembly: Assembly {
    func assemble(container: DIContainer) {
        container.register(
            type: ProfileRepositoryProtocol.self,
            component: ProfileRepository(networkService: container.resolve(type: NetworkServiceProtocol.self))
        )

        container.register(
            type: GetProfileDataUseCaseProtocol.self,
            component: GetProfileDataUseCase(repository: container.resolve(type: ProfileRepositoryProtocol.self))
        )

        container.register(
            type: UpdateProfileUseCaseProtocol.self,
            component: UpdateProfileUseCase(repository: container.resolve(type: ProfileRepositoryProtocol.self))
        )
    }
}
