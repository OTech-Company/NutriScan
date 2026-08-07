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
    private let quoteStore: HealthQuoteStoreProtocol

    init(
        service: NotificationServiceProtocol,
        muteStore: NotificationMuteStoreProtocol,
        quoteStore: HealthQuoteStoreProtocol = HealthQuoteStore()
    ) {
        self.service = service
        self.muteStore = muteStore
        self.quoteStore = quoteStore
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

        // 1. 08:00 QUOTE (Daily Morning Reflection & Inspiration)
        let todayQuote = quoteStore.quoteForToday()
        await scheduleTimeSlot(notification: .dailyQuoteSummary(quote: todayQuote), hour: 8, minute: 0)

        // 2. 09:00 FOOD (Breakfast)
        await scheduleTimeSlot(notification: .breakfastNudge, hour: 9, minute: 0)

        // 3. 11:00 WATER (Morning Pace)
        await scheduleTimeSlot(notification: .morningWaterPace, hour: 11, minute: 0)

        // 4. 13:30 FOOD (Lunch)
        await scheduleTimeSlot(notification: .lunchNudge, hour: 13, minute: 30)

        // 5. 14:00 WATER (Midday Pace)
        await scheduleTimeSlot(notification: .middayWaterPace, hour: 14, minute: 0)

        // 6. 16:00 STEPS (Afternoon Move)
        await scheduleTimeSlot(notification: .afternoonStepsMove, hour: 16, minute: 0)

        // 7. 17:00 WATER (Evening Pace)
        await scheduleTimeSlot(notification: .eveningWaterPace, hour: 17, minute: 0)

        // 8. 19:30 FOOD (Dinner)
        await scheduleTimeSlot(notification: .dinnerNudge, hour: 19, minute: 30)

        // 9. 20:30 WORKOUT
        await scheduleTimeSlot(notification: .workoutNudge, hour: 20, minute: 30)

        // 10. 21:30 STREAK
        await scheduleTimeSlot(notification: .streakProtection, hour: 21, minute: 30)

        // 11. Random 1x/week SCAN
        await scheduleTimeSlot(notification: .scanReengagement, weekday: 1, hour: 12, minute: 0) // Sunday
    }

    // MARK: - Today-Only Cancellation Helpers

    func cancelTodayOnlyAndProtectFuture(notification: AppNotification, hour: Int, minute: Int) async {
        // 1. Cancel today's pending notification request
        service.cancel(identifier: notification.identifier)

        // 2. Register a 3-Day Rolling Safety Net (Day+1, Day+2, Day+3) directly in iOS system memory
        let calendar = Calendar.current
        let now = Date()
        for dayOffset in 1...3 {
            if let futureDate = calendar.date(byAdding: .day, value: dayOffset, to: now) {
                var components = calendar.dateComponents([.year, .month, .day], from: futureDate)
                components.hour = hour
                components.minute = minute

                let futureTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                try? await service.schedule(notification, trigger: futureTrigger)
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