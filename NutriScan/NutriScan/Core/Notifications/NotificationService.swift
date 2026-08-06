//
//  NotificationService.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import UserNotifications
import Foundation

final class NotificationService: NSObject, NotificationServiceProtocol {

    private let center: UNUserNotificationCenter
    private let muteStore: NotificationMuteStoreProtocol
    private let historySaver: NotificationHistorySaving?
    private let evaluator: SmartNotificationEvaluatorProtocol

    init(
        center: UNUserNotificationCenter = .current(),
        muteStore: NotificationMuteStoreProtocol,
        historySaver: NotificationHistorySaving? = nil,
        evaluator: SmartNotificationEvaluatorProtocol
    ) {
        self.center = center
        self.muteStore = muteStore
        self.historySaver = historySaver
        self.evaluator = evaluator
        super.init()
        center.delegate = self
    }

    // MARK: - Authorization

    @discardableResult
    func requestAuthorizationIfNeeded() async -> Bool {
        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional:
            return true
        case .notDetermined:
            do {
                return try await center.requestAuthorization(options: [.alert, .sound, .badge])
            } catch {
                return false
            }
        case .denied, .ephemeral:
            return false
        @unknown default:
            return false
        }
    }

    // MARK: - Scheduling
    
    func schedule<T: LocalNotification>(_ notification: T, trigger: UNNotificationTrigger? = nil) async throws {
        // Silently skip muted categories or quiet hours — not an error
        guard !muteStore.isMuted(category: notification.category) else { return }
        guard !muteStore.isWithinQuietHours() else { return }

        let content = UNMutableNotificationContent()
        content.title = notification.title
        if let subtitle = notification.subtitle {
            content.subtitle = subtitle
        }
        content.body = notification.body
        content.sound = notification.sound
        content.categoryIdentifier = notification.category.rawValue

        let request = UNNotificationRequest(
            identifier: notification.identifier,
            content: content,
            trigger: trigger ?? notification.trigger
        )

        try await center.add(request)

        // Save to Notification History
        let historyItem = NotificationHistoryItem(
            title: notification.title,
            body: notification.body,
            category: notification.category,
            timestamp: Date(),
            isRead: false
        )
        historySaver?.saveItem(historyItem)
    }

    // MARK: - Cancellation

    func cancel(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        center.removeDeliveredNotifications(withIdentifiers: [identifier])
    }

    func cancel(identifiers: [String]) {
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
        center.removeDeliveredNotifications(withIdentifiers: identifiers)
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }

    // MARK: - Mute pass-throughs

    func setMuted(_ muted: Bool, category: NotificationCategory) {
        muteStore.setMuted(muted, category: category)
    }

    func isMuted(category: NotificationCategory) -> Bool {
        muteStore.isMuted(category: category)
    }

    // MARK: - Quiet Hours pass-throughs

    var isQuietHoursEnabled: Bool {
        muteStore.isQuietHoursEnabled
    }

    func setQuietHoursEnabled(_ enabled: Bool) {
        muteStore.setQuietHoursEnabled(enabled)
    }

    var quietHoursTimeString: String {
        let start = String(format: "%02d:00", muteStore.quietHoursStart)
        let end = String(format: "%02d:00", muteStore.quietHoursEnd)
        return "\(start) - \(end)"
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    /// Show banner + sound + badge only when smart evaluation, mute state,
    /// and quiet hours all allow it — even when the app is in the foreground.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if muteStore.isWithinQuietHours() {
            completionHandler([])
            return
        }

        let identifier = notification.request.identifier
        let content = notification.request.content
        let categoryRaw = content.categoryIdentifier

        if let category = NotificationCategory(rawValue: categoryRaw), muteStore.isMuted(category: category) {
            completionHandler([])
            return
        }

        Task {
            let shouldDeliver = await evaluator.shouldDeliverNotification(with: identifier)

            if shouldDeliver {
                let category = NotificationCategory(rawValue: categoryRaw) ?? .foodLog
                let historyItem = NotificationHistoryItem(
                    title: content.title,
                    body: content.body,
                    category: category,
                    timestamp: Date(),
                    isRead: false
                )
                self.historySaver?.saveItem(historyItem)

                completionHandler([.banner, .sound, .badge])
            } else {
                completionHandler([])
            }
        }
    }

    /// Handles user interaction when tapping a notification from background or terminated state.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let categoryIdentifier = response.notification.request.content.categoryIdentifier
        print("User tapped notification with category: \(categoryIdentifier)")
        completionHandler()
    }
}
