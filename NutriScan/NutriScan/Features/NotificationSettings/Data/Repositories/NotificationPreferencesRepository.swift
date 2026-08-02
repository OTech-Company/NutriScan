//
//  NotificationPreferencesRepository.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation


final class NotificationPreferencesRepository : NotificationPreferencesRepositoryProtocol {
    private let notificationService: NotificationServiceProtocol

    init(notificationService: NotificationServiceProtocol) {
        self.notificationService = notificationService
    }

    func isEnabled(for category: NotificationCategory) -> Bool {
        // Invert the isMuted logic: if it's NOT muted, it IS enabled.
        return !notificationService.isMuted(category: category)
    }

    func setEnabled(_ isEnabled: Bool, for category: NotificationCategory) {
        // Invert the logic: setting enabled to true means muting is false.
        notificationService.setMuted(!isEnabled, category: category)
    }
}
