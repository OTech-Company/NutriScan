//
//  SetNotificationCategoryEnabledUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

protocol SetNotificationCategoryEnabledUseCaseProtocol {
    func execute(category: NotificationCategory, enabled: Bool)
}

final class SetNotificationCategoryEnabledUseCase: SetNotificationCategoryEnabledUseCaseProtocol {
    private let repository: NotificationPreferencesRepositoryProtocol
    
    init(repository: NotificationPreferencesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(category: NotificationCategory, enabled: Bool) {
        repository.setEnabled(enabled, for: category)
    }
}
