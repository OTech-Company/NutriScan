//
//  NotificationCategory.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

enum NotificationCategory: String, CaseIterable, Identifiable {
    case steps
    case water
    case workout
    case foodLog
    case healthNews
    case healthQuotes
    case scanReminders
    case streak

    var id: String { rawValue }

    var displayTitle: String {
        switch self {
        case .steps: return "Steps"
        case .water: return "Water"
        case .workout: return "Workout"
        case .foodLog: return "Food Log"
        case .healthNews: return "Health News"
        case .healthQuotes: return "Health Quotes"
        case .scanReminders: return "Scan Reminders"
        case .streak: return "Streak"
        }
    }

    var icon: String {
        switch self {
        case .steps: return "figure.walk"
        case .water: return "drop.fill"
        case .workout: return "dumbbell.fill"
        case .foodLog: return "fork.knife"
        case .healthNews: return "newspaper.fill"
        case .healthQuotes: return "quote.bubble.fill"
        case .scanReminders: return "qrcode.viewfinder"
        case .streak: return "flame.fill"
        }
    }
}
