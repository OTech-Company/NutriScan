//
//  LocalNotification.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//
//  Protocol describing any schedulable local notification.
//  Add new notification types by conforming to this — no changes
//  to NotificationService required.

import UserNotifications

protocol LocalNotification {
    // Unique per notification instance
    var identifier: String { get }

    // Muting is based on this value
    var category: NotificationCategory { get }

    var title: String { get }
    var subtitle: String? { get }
    var body: String { get }
    var sound: UNNotificationSound { get }

    // The trigger to use when scheduling.
    // `nil` means fire immediately
    var trigger: UNNotificationTrigger? { get }
}

// MARK: - Default implementations
extension LocalNotification {
    var subtitle: String? { nil }
    var sound: UNNotificationSound { .default }
    var trigger: UNNotificationTrigger? { nil }
}
