//
//  NotificationSettingsFactory.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

@MainActor

enum NotificationSettingsFactory {

    static func makeNotificationSettingsViewModel() -> NotificationSettingsViewModel {
        let getPreferencesUseCase = DIContainer.shared.resolve(type: GetNotificationPreferencesUseCaseProtocol.self)
        let setCategoryEnabledUseCase = DIContainer.shared.resolve(type: SetNotificationCategoryEnabledUseCaseProtocol.self)
        let getQuietHoursUseCase = DIContainer.shared.resolve(type: GetQuietHoursUseCaseProtocol.self)
        let setQuietHoursEnabledUseCase = DIContainer.shared.resolve(type: SetQuietHoursEnabledUseCaseProtocol.self)

        return NotificationSettingsViewModel(
            getPreferencesUseCase: getPreferencesUseCase,
            setCategoryEnabledUseCase: setCategoryEnabledUseCase,
            getQuietHoursUseCase: getQuietHoursUseCase,
            setQuietHoursEnabledUseCase: setQuietHoursEnabledUseCase
        )
    }

    static func makeNotificationSettingsView() -> NotificationSettingsView {
        let viewModel = makeNotificationSettingsViewModel()
        return NotificationSettingsView(viewModel: viewModel)
    }
}
