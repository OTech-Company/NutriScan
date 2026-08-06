//
//  NotificationAssembly.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

struct NotificationAssembly: Assembly {
    func assemble(container: DIContainer) {
        
        let muteStore = NotificationMuteStore()
        container.register(
            type: NotificationMuteStoreProtocol.self,
            component: muteStore
        )

        // 1. Resolve Calories UseCase for Evaluator
        let caloriesUseCase = container.resolve(type: GetTodayCaloriesTrackingUseCaseProtocol.self)
        let evaluator = SmartNotificationEvaluator(getTodayCaloriesTrackingUseCase: caloriesUseCase)
        container.register(
            type: SmartNotificationEvaluatorProtocol.self,
            component: evaluator
        )

        // 2. Register NotificationService with injected evaluator and historySaver
        let historySaver = container.resolve(type: NotificationHistorySaving.self)
        let service = NotificationService(
            muteStore: muteStore,
            historySaver: historySaver,
            evaluator: evaluator
        )
        container.register(
            type: NotificationServiceProtocol.self,
            component: service
        )

        // 3. Register SmartNotificationScheduler with injected NotificationService
        let scheduler = SmartNotificationScheduler(service: service)
        container.register(
            type: SmartNotificationSchedulerProtocol.self,
            component: scheduler
        )

        // 4. Register NotificationBootstrapper
        let bootstrapper = NotificationBootstrapper(service: service, scheduler: scheduler)
        container.register(
            type: NotificationBootstrapperProtocol.self,
            component: bootstrapper
        )
    }
}
