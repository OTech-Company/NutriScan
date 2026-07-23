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
            component: ProfileRemoteDataSource(networkService: container.resolve(type: NetworkServiceProtocol.self))
        )
        
        // 2. Register Repository (now depending on the Remote Data Source)
        container.register(
            type: ProfileRepositoryProtocol.self,
            component: ProfileRepository(remoteDataSource: container.resolve(type: ProfileRemoteDataSourceProtocol.self))
        )

        // 3. Register Use Cases
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
