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

    private let getPreferencesUseCase: GetNotificationPreferencesUseCaseProtocol
    private let setCategoryEnabledUseCase: SetNotificationCategoryEnabledUseCaseProtocol

    init(
        getPreferencesUseCase: GetNotificationPreferencesUseCaseProtocol,
        setCategoryEnabledUseCase: SetNotificationCategoryEnabledUseCaseProtocol
    ) {
        self.getPreferencesUseCase = getPreferencesUseCase
        self.setCategoryEnabledUseCase = setCategoryEnabledUseCase
    }

    func loadPreferences() {
        self.toggleStates = getPreferencesUseCase.execute()
    }

    func toggleCategory(_ category: NotificationCategory, isOn: Bool) {
        toggleStates[category] = isOn
        setCategoryEnabledUseCase.execute(category: category, enabled: isOn)
    }
}
