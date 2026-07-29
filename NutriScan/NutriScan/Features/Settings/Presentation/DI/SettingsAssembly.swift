//
//  SettingsAssembly.swift
//  NutriScan
//

import Foundation

struct SettingsAssembly: Assembly {
    func assemble(container: DIContainer) {
        let localDataSource = SettingsLocalDataSourceImpl()
        container.register(
            type: SettingsLocalDataSourceProtocol.self,
            component: localDataSource
        )

        let repository = SettingsRepositoryImpl(localDataSource: localDataSource)
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
    }
}
