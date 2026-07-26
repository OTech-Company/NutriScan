//
//  ProfileAssembly.swift
//  NutriScan
//

import Foundation

struct ProfileAssembly: Assembly {
    func assemble(container: DIContainer) {

        // MARK: - Data Source (one, covers profile summary + streak)
        container.register(
            type: ProfileDataSourceProtocol.self,
            component: ProfileDataSource(
                networkService: container.resolve(type: NetworkServiceProtocol.self))
        )

        // MARK: - Repository (one, covers all profile use cases)
        container.register(
            type: ProfileRepositoryProtocol.self,
            component: ProfileRepository(
                dataSource: container.resolve(type: ProfileDataSourceProtocol.self))
        )

        // MARK: - Use Cases
        container.register(
            type: GetProfileSummaryUseCaseProtocol.self,
            component: GetProfileSummaryUseCase(
                repository: container.resolve(type: ProfileRepositoryProtocol.self))
        )

        container.register(
            type: UpdateFamilyMembersUseCaseProtocol.self,
            component: UpdateFamilyMembersUseCase(
                repository: container.resolve(type: ProfileRepositoryProtocol.self))
        )

        container.register(
            type: GetStreakUseCaseProtocol.self,
            component: GetStreakUseCase(
                repository: container.resolve(type: ProfileRepositoryProtocol.self))
        )

        container.register(
            type: UpdateStreakUseCaseProtocol.self,
            component: UpdateStreakUseCase(
                repository: container.resolve(type: ProfileRepositoryProtocol.self))
        )
    }
}
