//
//  NotificationPreferencesRepositoryProtocol.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

// MARK: - Protocol

protocol NotificationPreferencesRepositoryProtocol {
    func isEnabled(for category: NotificationCategory) -> Bool
    func setEnabled(_ isEnabled: Bool, for category: NotificationCategory)

    var isQuietHoursEnabled: Bool { get }
    func setQuietHoursEnabled(_ enabled: Bool)
    var quietHoursTimeString: String { get }
}
