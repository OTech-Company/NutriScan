//
//  NotificationServiceProtocol.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

protocol NotificationServiceProtocol {
    /// Returns `true` if authorized, `false` otherwise.
    @discardableResult
    func requestAuthorizationIfNeeded() async -> Bool

    /// Schedules a local notification.
    func schedule<T: LocalNotification>(_ notification: T) async throws

    /// Cancels a pending notification by its unique `identifier`.
    func cancel(identifier: String)

    /// Cancels all pending and delivered notifications.
    func cancelAll()

    /// Convenience pass-through: mutes or unmutes a notification category.
    func setMuted(_ muted: Bool, category: NotificationCategory)

    /// Convenience pass-through: returns whether a category is muted.
    func isMuted(category: NotificationCategory) -> Bool

    /// Quiet Hours pass-throughs
    var isQuietHoursEnabled: Bool { get }
    func setQuietHoursEnabled(_ enabled: Bool)
    var quietHoursTimeString: String { get }
}
