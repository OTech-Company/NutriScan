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
            type: ProfileSummaryRemoteDataSourceProtocol.self,
            component: ProfileSummaryRemoteDataSource(
                networkService: container.resolve(type: NetworkServiceProtocol.self))
        )
        
        container.register(
            type: ProfileSummaryRepositoryProtocol.self,
            component: ProfileSummaryRepository(
                remoteDataSource: container.resolve(type: ProfileSummaryRemoteDataSourceProtocol.self))
        )
        
        container.register(
            type: GetProfileSummaryUseCaseProtocol.self,
            component: GetProfileSummaryUseCase(
                repository: container.resolve(type: ProfileSummaryRepositoryProtocol.self))
        )
        
        container.register(
            type: UpdateFamilyMembersUseCaseProtocol.self,
            component: UpdateFamilyMembersUseCase(
                repository: container.resolve(type: ProfileSummaryRepositoryProtocol.self))
        )
    }
}
