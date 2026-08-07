//
//  AppNotification.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation
import UserNotifications

enum SmartNotificationIdentifier: String, CaseIterable {
    case breakfastNudge = "smart-breakfastNudge-0900"
    case morningWaterPace = "smart-morningWaterPace-1100"
    case restBreak0800 = "smart-restBreak-0800"
    case restBreak1400 = "smart-restBreak-1400"
    case restBreak2000 = "smart-restBreak-2000"
    case lunchNudge = "smart-lunchNudge-1330"
    case middayWaterPace = "smart-middayWaterPace-1400"
    case afternoonStepsMove = "smart-afternoonStepsMove-1600"
    case eveningWaterPace = "smart-eveningWaterPace-1700"
    case dinnerNudge = "smart-dinnerNudge-1930"
    case workoutNudge = "smart-workoutNudge-2030"
    case streakProtection = "smart-streakProtection-2130"
    case dailyQuoteSummary = "smart-dailyQuoteSummary-2200"
    case healthNewsNudge = "smart-healthNews"
    case scanReengagement = "smart-scanReengagement-weekly"
}

enum AppNotification: LocalNotification {

    // Smart Time-Slot & Behavioral Notifications
    case breakfastNudge                 // 09:00 - FOOD
    case morningWaterPace              // 11:00 - WATER
    case pauseAndResetNudge(slot: Int)  // Every 6 hours (08:00, 14:00, 20:00) - BREAK
    case lunchNudge                     // 13:30 - FOOD
    case middayWaterPace               // 14:00 - WATER
    case afternoonStepsMove            // 16:00 - STEPS
    case eveningWaterPace             // 17:00 - WATER
    case dinnerNudge                    // 19:30 - FOOD
    case workoutNudge                   // 20:30 - WORKOUT
    case streakProtection               // 21:30 - STREAK
    case dailyQuoteSummary(quote: String)  // 08:00 - QUOTE
    case healthNewsNudge(headline: String) // 12:30 - NEWS
    case scanReengagement               // Random weekly - SCAN

    // MARK: - identifier

    var identifier: String {
        switch self {
        case .breakfastNudge:
            return SmartNotificationIdentifier.breakfastNudge.rawValue
        case .morningWaterPace:
            return SmartNotificationIdentifier.morningWaterPace.rawValue
        case .pauseAndResetNudge(let slot):
            switch slot {
            case 1: return SmartNotificationIdentifier.restBreak0800.rawValue
            case 2: return SmartNotificationIdentifier.restBreak1400.rawValue
            default: return SmartNotificationIdentifier.restBreak2000.rawValue
            }
        case .lunchNudge:
            return SmartNotificationIdentifier.lunchNudge.rawValue
        case .middayWaterPace:
            return SmartNotificationIdentifier.middayWaterPace.rawValue
        case .afternoonStepsMove:
            return SmartNotificationIdentifier.afternoonStepsMove.rawValue
        case .eveningWaterPace:
            return SmartNotificationIdentifier.eveningWaterPace.rawValue
        case .dinnerNudge:
            return SmartNotificationIdentifier.dinnerNudge.rawValue
        case .workoutNudge:
            return SmartNotificationIdentifier.workoutNudge.rawValue
        case .streakProtection:
            return SmartNotificationIdentifier.streakProtection.rawValue
        case .dailyQuoteSummary:
            return SmartNotificationIdentifier.dailyQuoteSummary.rawValue
        case .healthNewsNudge(let headline):
            return "\(SmartNotificationIdentifier.healthNewsNudge.rawValue)-\(headline.lowercased().replacingOccurrences(of: " ", with: "_"))"
        case .scanReengagement:
            return SmartNotificationIdentifier.scanReengagement.rawValue
        }
    }

    // MARK: - category (stable per case, used for muting)

    var category: NotificationCategory {
        switch self {
        case .breakfastNudge, .lunchNudge, .dinnerNudge:
            return .foodLog
        case .morningWaterPace, .middayWaterPace, .eveningWaterPace:
            return .water
        case .pauseAndResetNudge:
            return .breakTime
        case .afternoonStepsMove:
            return .steps
        case .workoutNudge:
            return .workout
        case .streakProtection:
            return .streak
        case .dailyQuoteSummary:
            return .healthQuotes
        case .healthNewsNudge:
            return .healthNews
        case .scanReengagement:
            return .scanReminders
        }
    }

    // MARK: - Content

    var title: String {
        switch self {
        case .breakfastNudge:
            return "Breakfast Time 🍳"
        case .morningWaterPace, .middayWaterPace, .eveningWaterPace:
            return "Stay Hydrated 💧"
        case .pauseAndResetNudge:
            return "Pause & Reset 🌿"
        case .lunchNudge:
            return "Lunch Reminder 🥗"
        case .afternoonStepsMove:
            return "Time to Move! 🏃‍♂️"
        case .dinnerNudge:
            return "Dinner Nudge 🍲"
        case .workoutNudge:
            return "Daily Workout 🏋️‍♂️"
        case .streakProtection:
            return "Protect Your Streak! 🔥"
        case .dailyQuoteSummary:
            return "Daily Reflection 💡"
        case .healthNewsNudge:
            return "Health Insights 📰"
        case .scanReengagement:
            return "Scan & Learn 🔍"
        }
    }

    var subtitle: String? {
        nil
    }

    var body: String {
        switch self {
        case .breakfastNudge:
            return "Don't forget to log your breakfast to start your day strong!"
        case .morningWaterPace:
            return "You're a bit behind your morning water goal. Have a glass of water!"
        case .pauseAndResetNudge:
            return "Your back, your eyes, your focus — all need a minute. Stand up, breathe, look away from the screen. You'll come back sharper."
        case .lunchNudge:
            return "Remember to log your lunch to keep your nutrition tracking accurate."
        case .middayWaterPace:
            return "Halfway through the day! Drink a glass of water to stay energized."
        case .afternoonStepsMove:
            return "You're behind your daily step goal. Take a quick walk to catch up!"
        case .eveningWaterPace:
            return "Almost there! Sip another glass of water toward your daily target."
        case .dinnerNudge:
            return "Complete today's food log by recording your dinner."
        case .workoutNudge:
            return "No exercise logged today yet. A short workout keeps your momentum going!"
        case .streakProtection:
            return "Don't lose your active streak! Complete today's log before midnight."
        case .dailyQuoteSummary(let quote):
            return quote
        case .healthNewsNudge(let headline):
            return headline
        case .scanReengagement:
            return "Haven't scanned a food product in a while? Scan your next meal to discover nutrition facts!"
        }
    }
}
