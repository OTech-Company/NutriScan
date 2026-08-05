//
//  NotificationHistoryAssembly.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

struct NotificationHistoryAssembly: Assembly {
    func assemble(container: DIContainer) {
        let localDataSource = NotificationHistoryLocalDataSource()
        let repository = NotificationHistoryRepositoryImpl(dataSource: localDataSource)
        
        container.register(
            type: NotificationHistoryRepositoryProtocol.self,
            component: repository
        )
        
        container.register(
            type: GetNotificationHistoryUseCaseProtocol.self,
            component: GetNotificationHistoryUseCase(repository: repository)
        )
        container.register(
            type: ClearNotificationHistoryUseCaseProtocol.self,
            component: ClearNotificationHistoryUseCase(repository: repository)
        )
        container.register(
            type: DeleteNotificationHistoryItemUseCaseProtocol.self,
            component: DeleteNotificationHistoryItemUseCase(repository: repository)
        )
        let saveUseCase = SaveNotificationHistoryItemUseCase(repository: repository)
        container.register(
            type: SaveNotificationHistoryItemUseCaseProtocol.self,
            component: saveUseCase
        )
        container.register(
            type: NotificationHistorySaving.self,
            component: saveUseCase
        )
        container.register(
            type: MarkNotificationAsReadUseCaseProtocol.self,
            component: MarkNotificationAsReadUseCase(repository: repository)
        )
    }
}
