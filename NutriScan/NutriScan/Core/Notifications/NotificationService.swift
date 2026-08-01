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

    init(
        center: UNUserNotificationCenter = .current(),
        muteStore: NotificationMuteStoreProtocol
    ) {
        self.center = center
        self.muteStore = muteStore
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
    
    // MARK: - Authorization

    private func hasAuthorization() async -> Bool {
         let settings = await center.notificationSettings()
         return settings.authorizationStatus == .authorized
             || settings.authorizationStatus == .provisional
     }
    
    // MARK: - Scheduling

    func schedule<T: LocalNotificationType>(_ notification: T) async throws {
        // Silently skip muted categories — not an error
        guard !muteStore.isMuted(category: notification.category) else { return }
        guard await hasAuthorization() else { return }

        let content = UNMutableNotificationContent()
        content.title = notification.title
        if let subtitle = notification.subtitle {
            content.subtitle = subtitle
        }
        content.body = notification.body
        content.sound = notification.sound
        content.categoryIdentifier = notification.category

        let request = UNNotificationRequest(
            identifier: notification.identifier,
            content: content,
            trigger: notification.trigger
        )

        try await center.add(request)
    }

    // MARK: - Cancellation

    func cancel(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        center.removeDeliveredNotifications(withIdentifiers: [identifier])
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }

    // MARK: - Mute pass-throughs

    func setMuted(_ muted: Bool, category: String) {
        muteStore.setMuted(muted, category: category)
    }

    func isMuted(category: String) -> Bool {
        muteStore.isMuted(category: category)
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    /// Show banner + sound + badge even when the app is in the foreground.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
