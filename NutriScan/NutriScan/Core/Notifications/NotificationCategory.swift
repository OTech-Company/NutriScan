//
//  NotificationCategory.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

// MARK: - Section grouping

enum NotificationSection: String, CaseIterable {
    case fitnessAndTracking = "Fitness & Tracking"
    case reminders          = "Reminders"
    case contentAndNews     = "Content & News"

    var displayTitle: String {
        switch self {
        case .fitnessAndTracking: return LocalizationKeys.Notifications.sectionFitness.localized
        case .reminders:          return LocalizationKeys.Notifications.sectionReminders.localized
        case .contentAndNews:     return LocalizationKeys.Notifications.sectionContent.localized
        }
    }
}

// MARK: - Category

enum NotificationCategory: String, CaseIterable, Identifiable, Codable {
    case steps
    case water
    case workout
    case foodLog
    case streak
    case breakTime
    case scanReminders
    case healthNews
    case healthQuotes

    var id: String { rawValue }

    var displayTitle: String {
        switch self {
        case .steps:         return LocalizationKeys.Notifications.categorySteps.localized
        case .water:         return LocalizationKeys.Notifications.categoryWater.localized
        case .workout:       return LocalizationKeys.Notifications.categoryWorkout.localized
        case .foodLog:       return LocalizationKeys.Notifications.categoryFoodLog.localized
        case .streak:        return LocalizationKeys.Notifications.categoryStreak.localized
        case .breakTime:     return LocalizationKeys.Notifications.categoryBreakTime.localized
        case .scanReminders: return LocalizationKeys.Notifications.categoryScanReminders.localized
        case .healthNews:    return LocalizationKeys.Notifications.categoryHealthNews.localized
        case .healthQuotes:  return LocalizationKeys.Notifications.categoryHealthQuotes.localized
        }
    }

    var icon: String {
        switch self {
        case .steps:         return "figure.walk"
        case .water:         return "drop.fill"
        case .workout:       return "dumbbell.fill"
        case .foodLog:       return "fork.knife"
        case .streak:        return "flame.fill"
        case .breakTime:     return "cup.and.saucer.fill"
        case .scanReminders: return "qrcode.viewfinder"
        case .healthNews:    return "newspaper.fill"
        case .healthQuotes:  return "quote.bubble.fill"
        }
    }

    var section: NotificationSection {
        switch self {
        case .steps, .water, .workout, .foodLog, .streak, .breakTime:
            return .fitnessAndTracking
        case .scanReminders:
            return .reminders
        case .healthNews, .healthQuotes:
            return .contentAndNews
        }
    }
}
