//
//  SharedProfileAssembly.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

struct SharedProfileAssembly: Assembly {
    func assemble(container: DIContainer) {
        container.register(
            type: UserProfileStore.self, component: UserProfileStore())

        container.register(
            type: UserProfileDataSourceProtocol.self,
            component: UserProfileDataSource()
        )

        container.register(
            type: UserProfileRepositoryProtocol.self,
            component: UserProfileRepository()
        )

        container.register(
            type: FetchAndCacheProfileUseCaseProtocol.self,
            component: FetchAndCacheProfileUseCase()
        )

        container.register(
            type: ObserveProfileUseCaseProtocol.self,
            component: ObserveProfileUseCase()
        )

        container.register(
            type: UpdateProfileUseCaseProtocol.self,
            component: UpdateProfileUseCase()
        )
        
        container.register(
            type: GetReferenceDataUseCaseProtocol.self,
            component: GetReferenceDataUseCase()
        )
        
        container.register(
            type: UploadProfileImageUseCaseProtocol.self,
            component: UploadProfileImageUseCase()
        )
    }
}
