//
//  NotificationSettingsAssembly.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

struct NotificationSettingsAssembly: Assembly {
    func assemble(container: DIContainer) {

        // Data / Repositories
        let notificationService = container.resolve(type: NotificationServiceProtocol.self)
        let repository = NotificationPreferencesRepository(notificationService: notificationService)
        container.register(type: NotificationPreferencesRepositoryProtocol.self, component: repository)

        // Domain / UseCases
        container.register(
            type: GetNotificationPreferencesUseCaseProtocol.self,
            component: GetNotificationPreferencesUseCase(repository: repository)
        )
        container.register(
            type: SetNotificationCategoryEnabledUseCaseProtocol.self,
            component: SetNotificationCategoryEnabledUseCase(repository: repository)
        )
    }
}
