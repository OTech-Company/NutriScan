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
            type: SharedProfileStore.self, component: SharedProfileStore())

        container.register(
            type: SharedProfileDataSourceProtocol.self,
            component: SharedProfileDataSource()
        )

        container.register(
            type: SharedProfileRepositoryProtocol.self,
            component: SharedProfileRepository()
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
            type: GetStreakUseCaseProtocol.self,
            component: GetStreakUseCase()
        )

        container.register(
            type: UpdateStreakUseCaseProtocol.self,
            component: UpdateStreakUseCase()
        )

        container.register(
            type: UpdateFamilyMembersUseCaseProtocol.self,
            component: UpdateFamilyMembersUseCase()
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
