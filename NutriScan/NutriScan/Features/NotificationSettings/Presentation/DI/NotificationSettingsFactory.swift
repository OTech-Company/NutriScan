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

        return NotificationSettingsViewModel(
            getPreferencesUseCase: getPreferencesUseCase,
            setCategoryEnabledUseCase: setCategoryEnabledUseCase
        )
    }

    static func makeNotificationSettingsView() -> NotificationSettingsView {
        let viewModel = makeNotificationSettingsViewModel()
        return NotificationSettingsView(viewModel: viewModel)
    }
}
