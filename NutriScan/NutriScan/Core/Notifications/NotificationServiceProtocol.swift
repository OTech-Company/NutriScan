//
//  NotificationServiceProtocol.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//


import UserNotifications
import Foundation

protocol NotificationServiceProtocol: AnyObject {
    @discardableResult
    func requestAuthorizationIfNeeded() async -> Bool

    func schedule<T: LocalNotification>(_ notification: T, trigger: UNNotificationTrigger?) async throws

    func cancel(identifier: String)
    func cancelAll()

    func setMuted(_ muted: Bool, category: NotificationCategory)
    func isMuted(category: NotificationCategory) -> Bool

    var isQuietHoursEnabled: Bool { get }
    func setQuietHoursEnabled(_ enabled: Bool)
    var quietHoursTimeString: String { get }
}


extension NotificationServiceProtocol {
    func schedule<T: LocalNotification>(_ notification: T) async throws {
        try await schedule(notification, trigger: nil)
    }
}