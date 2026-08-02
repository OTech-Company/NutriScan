//
//  NotificationPreferencesRepositoryProtocol 2.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//



// MARK: - Protocol

protocol NotificationPreferencesRepositoryProtocol {
    func isEnabled(for category: NotificationCategory) -> Bool
    func setEnabled(_ isEnabled: Bool, for category: NotificationCategory)
}
