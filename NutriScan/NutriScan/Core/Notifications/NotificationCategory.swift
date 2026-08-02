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
}

// MARK: - Category

enum NotificationCategory: String, CaseIterable, Identifiable {
    case steps
    case water
    case workout
    case foodLog
    case streak
    case scanReminders
    case healthNews
    case healthQuotes

    var id: String { rawValue }

    var displayTitle: String {
        switch self {
        case .steps:         return "Steps"
        case .water:         return "Water"
        case .workout:       return "Workout"
        case .foodLog:       return "Food Log"
        case .streak:        return "Streak"
        case .scanReminders: return "Scan Reminders"
        case .healthNews:    return "Health News"
        case .healthQuotes:  return "Health Quotes"
        }
    }

    var icon: String {
        switch self {
        case .steps:         return "figure.walk"
        case .water:         return "drop.fill"
        case .workout:       return "dumbbell.fill"
        case .foodLog:       return "fork.knife"
        case .streak:        return "flame.fill"
        case .scanReminders: return "qrcode.viewfinder"
        case .healthNews:    return "newspaper.fill"
        case .healthQuotes:  return "quote.bubble.fill"
        }
    }

    var section: NotificationSection {
        switch self {
        case .steps, .water, .workout, .foodLog, .streak:
            return .fitnessAndTracking
        case .scanReminders:
            return .reminders
        case .healthNews, .healthQuotes:
            return .contentAndNews
        }
    }
}
