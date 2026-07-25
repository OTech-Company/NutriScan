//
//  ProfileAssembly.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//
import Foundation

struct ProfileAssembly: Assembly {
    func assemble(container: DIContainer) {

        // MARK: - Profile Summary
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

        // MARK: - Streak
        container.register(
            type: StreakRemoteDataSourceProtocol.self,
            component: StreakMockRemoteDataSource()
        )

        container.register(
            type: StreakRepositoryProtocol.self,
            component: StreakRepository(
                remoteDataSource: container.resolve(
                    type: StreakRemoteDataSourceProtocol.self))
        )

        container.register(
            type: GetStreakUseCaseProtocol.self,
            component: GetStreakUseCase(
                repository: container.resolve(
                    type: StreakRepositoryProtocol.self))
        )

        container.register(
            type: UpdateStreakUseCaseProtocol.self,
            component: UpdateStreakUseCase(
                repository: container.resolve(
                    type: StreakRepositoryProtocol.self))
        )
    }
}
