//
//  SettingsAssembly.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

struct SettingsAssembly: Assembly {
    func assemble(container: DIContainer) {
        let localDataSource = SettingsLocalDataSourceImpl()
        container.register(
            type: SettingsLocalDataSourceProtocol.self,
            component: localDataSource
        )

        let repository = SettingsRepositoryImpl(
            localDataSource: localDataSource)
        container.register(
            type: SettingsRepositoryProtocol.self,
            component: repository
        )

        container.register(
            type: GetAppearanceUseCaseProtocol.self,
            component: GetAppearanceUseCase(repository: repository)
        )
        container.register(
            type: UpdateAppearanceUseCaseProtocol.self,
            component: UpdateAppearanceUseCase(repository: repository)
        )
        container.register(
            type: GetLanguageUseCaseProtocol.self,
            component: GetLanguageUseCase(repository: repository)
        )
        container.register(
            type: UpdateLanguageUseCaseProtocol.self,
            component: UpdateLanguageUseCase(repository: repository)
        )
        container.register(
            type: DeleteAccountUseCaseProtocol.self,
            component: DeleteAccountUseCase(repository: repository)
        )

        // MARK: - Help Feature Data Sources
        container.register(
            type: HelpLocalDataSourceProtocol.self,
            component: HelpLocalDataSourceImpl()
        )

        // MARK: - Help Feature Repositories
        container.register(
            type: HelpRepositoryProtocol.self,
            component: HelpRepository(
                localDataSource: container.resolve(
                    type: HelpLocalDataSourceProtocol.self)
            )
        )

        // MARK: - Help Feature Use Cases
        container.register(
            type: GetFaqUseCaseProtocol.self,
            component: GetFaqUseCase(
                repository: container.resolve(type: HelpRepositoryProtocol.self)
            )
        )

        // MARK: - Terms Feature
        container.register(
            type: TermsLocalDataSourceProtocol.self,
            component: TermsLocalDataSourceImpl()
        )

        container.register(
            type: TermsRepositoryProtocol.self,
            component: TermsRepositoryImpl(
                localDataSource: container.resolve(type: TermsLocalDataSourceProtocol.self)
            )
        )

        container.register(
            type: GetTermsUseCaseProtocol.self,
            component: GetTermsUseCase(
                repository: container.resolve(type: TermsRepositoryProtocol.self)
            )
        )
    }
}
