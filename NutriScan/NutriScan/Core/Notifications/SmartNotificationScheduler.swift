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
    func cancelTodayOnlyAndProtectFuture(notification: AppNotification, hour: Int, minute: Int) async
    func cancelBreakfastNudge() async
    func cancelMorningWaterPace() async
    func cancelLunchNudge() async
    func cancelMiddayWaterPace() async
    func cancelAfternoonStepsMove() async
    func cancelEveningWaterPace() async
    func cancelDinnerNudge() async
    func cancelWorkoutNudge() async
    func cancelStreakProtection() async
}

final class SmartNotificationScheduler: SmartNotificationSchedulerProtocol {
    private let service: NotificationServiceProtocol
    private let muteStore: NotificationMuteStoreProtocol

    init(
        service: NotificationServiceProtocol,
        muteStore: NotificationMuteStoreProtocol
    ) {
        self.service = service
        self.muteStore = muteStore
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

    // MARK: - Today-Only Cancellation Helpers

    func cancelTodayOnlyAndProtectFuture(notification: AppNotification, hour: Int, minute: Int) async {
        // 1. Cancel today's pending notification request
        service.cancel(identifier: notification.identifier)

        // 2. Schedule a one-time trigger for tomorrow at target hour:minute in iOS system memory
        let calendar = Calendar.current
        let now = Date()
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) {
            var tomorrowComponents = calendar.dateComponents([.year, .month, .day], from: tomorrow)
            tomorrowComponents.hour = hour
            tomorrowComponents.minute = minute

            let tomorrowTrigger = UNCalendarNotificationTrigger(dateMatching: tomorrowComponents, repeats: false)
            try? await service.schedule(notification, trigger: tomorrowTrigger)
        }

        // 3. Re-register daily repeating schedule after today's time passes
        if let targetToday = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now), now > targetToday {
            await scheduleTimeSlot(notification: notification, hour: hour, minute: minute)
        } else if let triggerAfter = calendar.date(bySettingHour: hour, minute: 1, second: 0, of: now) {
            let delay = max(1.0, triggerAfter.timeIntervalSince(now))
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                Task {
                    await self?.scheduleTimeSlot(notification: notification, hour: hour, minute: minute)
                }
            }
        }
    }

    func cancelBreakfastNudge() async {
        await cancelTodayOnlyAndProtectFuture(notification: .breakfastNudge, hour: 9, minute: 0)
    }

    func cancelMorningWaterPace() async {
        await cancelTodayOnlyAndProtectFuture(notification: .morningWaterPace, hour: 11, minute: 0)
    }

    func cancelLunchNudge() async {
        await cancelTodayOnlyAndProtectFuture(notification: .lunchNudge, hour: 13, minute: 30)
    }

    func cancelMiddayWaterPace() async {
        await cancelTodayOnlyAndProtectFuture(notification: .middayWaterPace, hour: 14, minute: 0)
    }

    func cancelAfternoonStepsMove() async {
        await cancelTodayOnlyAndProtectFuture(notification: .afternoonStepsMove, hour: 16, minute: 0)
    }

    func cancelEveningWaterPace() async {
        await cancelTodayOnlyAndProtectFuture(notification: .eveningWaterPace, hour: 17, minute: 0)
    }

    func cancelDinnerNudge() async {
        await cancelTodayOnlyAndProtectFuture(notification: .dinnerNudge, hour: 19, minute: 30)
    }

    func cancelWorkoutNudge() async {
        await cancelTodayOnlyAndProtectFuture(notification: .workoutNudge, hour: 20, minute: 30)
    }

    func cancelStreakProtection() async {
        await cancelTodayOnlyAndProtectFuture(notification: .streakProtection, hour: 21, minute: 30)
    }

    private func scheduleTimeSlot(
        notification: AppNotification,
        weekday: Int? = nil,
        hour: Int,
        minute: Int
    ) async {
        // Skip scheduling and cancel pending request if category is muted or hour falls in quiet hours
        guard !muteStore.isMuted(category: notification.category) else {
            service.cancel(identifier: notification.identifier)
            return
        }
        if muteStore.isQuietHoursEnabled && (hour >= 22 || hour < 7) {
            service.cancel(identifier: notification.identifier)
            return
        }

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