//
//  NotificationBootstrapper.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 06/08/2026.
//

import Foundation

protocol NotificationBootstrapperProtocol {
    func start() async
}

final class NotificationBootstrapper: NotificationBootstrapperProtocol {
    private let service: NotificationServiceProtocol
    private let scheduler: SmartNotificationSchedulerProtocol
    private let healthKitStepDataSource: HealthKitStepDataSource

    init(
        service: NotificationServiceProtocol,
        scheduler: SmartNotificationSchedulerProtocol,
        healthKitStepDataSource: HealthKitStepDataSource
    ) {
        self.service = service
        self.scheduler = scheduler
        self.healthKitStepDataSource = healthKitStepDataSource
    }

    func start() async {
        let granted = await service.requestAuthorizationIfNeeded()
        guard granted else { return }
        await scheduler.scheduleAllSmartNotifications()
        healthKitStepDataSource.enableBackgroundStepMonitoring(scheduler: scheduler)
    }
}
