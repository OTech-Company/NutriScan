//
//  SmartNotificationScheduler.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 06/08/2026.
//

import Foundation
import UserNotifications

protocol SmartNotificationSchedulerProtocol {
    func scheduleAllSmartNotifications() async
}

final class SmartNotificationScheduler: SmartNotificationSchedulerProtocol {
    private let service: NotificationServiceProtocol

    init(service: NotificationServiceProtocol) {
        self.service = service
    }

    private static let allIdentifiers: [String] = [
        AppNotification.breakfastNudge.identifier,
        AppNotification.morningWaterPace.identifier,
        AppNotification.lunchNudge.identifier,
        AppNotification.middayWaterPace.identifier,
        AppNotification.afternoonStepsMove.identifier,
        AppNotification.eveningWaterPace.identifier,
        AppNotification.dinnerNudge.identifier,
        AppNotification.workoutNudge.identifier,
        AppNotification.streakProtection.identifier,
        AppNotification.dailyQuoteSummary(quote: "").identifier,
        AppNotification.scanReengagement.identifier
    ]

    func scheduleAllSmartNotifications() async {
        // Remove old pending smart notifications to avoid duplicate triggers
        for identifier in Self.allIdentifiers {
            service.cancel(identifier: identifier)
        }

        // 1. 09:00 FOOD (Breakfast)
        await scheduleTimeSlot(notification: .breakfastNudge, hour: 9, minute: 0)

        // 2. 11:00 WATER (Morning Pace)
        await scheduleTimeSlot(notification: .morningWaterPace, hour: 11, minute: 0)

        // 3. 13:30 FOOD (Lunch)
        await scheduleTimeSlot(notification: .lunchNudge, hour: 13, minute: 30)

        // 4. 14:00 WATER (Midday Pace)
        await scheduleTimeSlot(notification: .middayWaterPace, hour: 14, minute: 0)

        // 5. 16:00 STEPS (Afternoon Move)
        await scheduleTimeSlot(notification: .afternoonStepsMove, hour: 16, minute: 0)

        // 6. 17:00 WATER (Evening Pace)
        await scheduleTimeSlot(notification: .eveningWaterPace, hour: 17, minute: 0)

        // 7. 19:30 FOOD (Dinner)
        await scheduleTimeSlot(notification: .dinnerNudge, hour: 19, minute: 30)

        // 8. 20:30 WORKOUT
        await scheduleTimeSlot(notification: .workoutNudge, hour: 20, minute: 30)

        // 9. 21:30 STREAK
        await scheduleTimeSlot(notification: .streakProtection, hour: 21, minute: 30)

        // 10. 22:00 QUOTE (Guaranteed Daily Touch)
        let defaultQuote = "Health is a state of complete harmony of the body, mind and spirit."
        await scheduleTimeSlot(notification: .dailyQuoteSummary(quote: defaultQuote), hour: 22, minute: 0)

        // 11. Random 1x/week SCAN
        await scheduleTimeSlot(notification: .scanReengagement, weekday: 1, hour: 12, minute: 0) // Sunday
    }

    private func scheduleTimeSlot(
        notification: AppNotification,
        weekday: Int? = nil,
        hour: Int,
        minute: Int
    ) async {
        var dateComponents = DateComponents()
        if let weekday = weekday {
            dateComponents.weekday = weekday
        }
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        do {
            try await service.schedule(notification, trigger: trigger)
        } catch {
            print("Failed to schedule smart notification \(notification.identifier): \(error)")
        }
    }
}