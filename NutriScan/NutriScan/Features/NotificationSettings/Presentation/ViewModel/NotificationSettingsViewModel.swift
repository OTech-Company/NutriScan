//
//  NotificationSettingsViewModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class NotificationSettingsViewModel {

    var toggleStates: [NotificationCategory: Bool] = [:]
    var isQuietHoursEnabled: Bool = true
    var quietHoursTimeString: String = "22:00 - 07:00"

    private let getPreferencesUseCase: GetNotificationPreferencesUseCaseProtocol
    private let setCategoryEnabledUseCase: SetNotificationCategoryEnabledUseCaseProtocol
    private let getQuietHoursUseCase: GetQuietHoursUseCaseProtocol
    private let setQuietHoursEnabledUseCase: SetQuietHoursEnabledUseCaseProtocol
    private let scheduler: SmartNotificationSchedulerProtocol

    init(
        getPreferencesUseCase: GetNotificationPreferencesUseCaseProtocol,
        setCategoryEnabledUseCase: SetNotificationCategoryEnabledUseCaseProtocol,
        getQuietHoursUseCase: GetQuietHoursUseCaseProtocol,
        setQuietHoursEnabledUseCase: SetQuietHoursEnabledUseCaseProtocol,
        scheduler: SmartNotificationSchedulerProtocol
    ) {
        self.getPreferencesUseCase = getPreferencesUseCase
        self.setCategoryEnabledUseCase = setCategoryEnabledUseCase
        self.getQuietHoursUseCase = getQuietHoursUseCase
        self.setQuietHoursEnabledUseCase = setQuietHoursEnabledUseCase
        self.scheduler = scheduler
    }

    func loadPreferences() {
        self.toggleStates = getPreferencesUseCase.execute()
        let quietHoursInfo = getQuietHoursUseCase.execute()
        self.isQuietHoursEnabled = quietHoursInfo.isEnabled
        self.quietHoursTimeString = quietHoursInfo.timeRangeString
    }

    func toggleCategory(_ category: NotificationCategory, isOn: Bool) {
        toggleStates[category] = isOn
        setCategoryEnabledUseCase.execute(category: category, enabled: isOn)
        Task {
            await scheduler.scheduleAllSmartNotifications()
        }
    }

    func toggleQuietHours(isOn: Bool) {
        isQuietHoursEnabled = isOn
        setQuietHoursEnabledUseCase.execute(enabled: isOn)
        Task {
            await scheduler.scheduleAllSmartNotifications()
        }
    }
}
