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

        // 3. Register HealthQuoteStore & SmartNotificationScheduler
        let quoteStore = HealthQuoteStore()
        container.register(
            type: HealthQuoteStoreProtocol.self,
            component: quoteStore
        )
        let fetchNewsUseCase = container.resolve(type: FetchTopHeadlinesUseCaseProtocol.self)
        let scheduler = SmartNotificationScheduler(
            service: service,
            muteStore: muteStore,
            quoteStore: quoteStore,
            fetchTopHeadlinesUseCase: fetchNewsUseCase
        )
        container.register(
            type: SmartNotificationSchedulerProtocol.self,
            component: scheduler
        )

        // 4. Register NotificationBootstrapper with injected HealthKitStepDataSource
        let healthKitSource = container.resolve(type: HealthKitStepDataSource.self)
        let bootstrapper = NotificationBootstrapper(
            service: service,
            scheduler: scheduler,
            healthKitStepDataSource: healthKitSource
        )
        container.register(
            type: NotificationBootstrapperProtocol.self,
            component: bootstrapper
        )
    }
}
