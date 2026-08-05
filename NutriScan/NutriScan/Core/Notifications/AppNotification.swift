//
//  AppNotification.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation
import UserNotifications

enum AppNotification: LocalNotification {

    case stepsReminder(currentSteps: Int, goalSteps: Int)
    case waterReminder(currentGlasses: Int, goalGlasses: Int)
    case workoutReminder
    case foodLogReminder
    case streakReminder
    case healthNewsUpdate(headline: String)
    case healthQuote(quote: String)
    case favoriteAdded(itemTitle: String, itemSubtitle: String)
    case scanComplete(itemName: String)

    // MARK: - identifier

    var identifier: String {
        switch self {
        case .stepsReminder:
            return "stepsReminder-\(UUID().uuidString)"
        case .waterReminder:
            return "waterReminder-\(UUID().uuidString)"
        case .workoutReminder:
            return "workoutReminder-\(UUID().uuidString)"
        case .foodLogReminder:
            return "foodLogReminder-\(UUID().uuidString)"
        case .streakReminder:
            return "streakReminder"
        case .healthNewsUpdate(let headline):
            return "healthNews-\(headline.lowercased().replacingOccurrences(of: " ", with: "_"))"
        case .healthQuote:
            return "healthQuote-\(UUID().uuidString)"
        case .favoriteAdded(let itemTitle, _):
            return "favoriteAdded-\(itemTitle.lowercased().replacingOccurrences(of: " ", with: "_"))"
        case .scanComplete(let itemName):
            return "scanComplete-\(itemName.lowercased().replacingOccurrences(of: " ", with: "_"))"
        }
    }

    // MARK: - category (stable per case, used for muting)

    var category: NotificationCategory {
        switch self {
        case .stepsReminder:        return .steps
        case .waterReminder:        return .water
        case .workoutReminder:      return .workout
        case .foodLogReminder:      return .foodLog
        case .streakReminder:       return .streak
        case .healthNewsUpdate:     return .healthNews
        case .healthQuote:          return .healthQuotes
        case .favoriteAdded:        return .scanReminders
        case .scanComplete:         return .scanReminders
        }
    }

    // MARK: - Content

    var title: String {
        switch self {
        case .stepsReminder:
            return "Time to Move! 🏃‍♂️"
        case .waterReminder:
            return "Stay Hydrated 💧"
        case .workoutReminder:
            return "Daily Workout 🏋️‍♂️"
        case .foodLogReminder:
            return "Log Your Meal 🥗"
        case .streakReminder:
            return "Keep Your Streak Going! 🔥"
        case .healthNewsUpdate:
            return "Health News 📰"
        case .healthQuote:
            return "Daily Health Quote 💡"
        case .favoriteAdded:
            return "Added to Favorites 🌟"
        case .scanComplete:
            return "Scan Complete ✅"
        }
    }

    var subtitle: String? {
        switch self {
        case .favoriteAdded(let itemTitle, _):
            return itemTitle
        case .scanComplete(let itemName):
            return itemName
        default:
            return nil
        }
    }

    var body: String {
        switch self {
        case .stepsReminder(let current, let goal):
            return "You're at \(current)/\(goal) steps today. Keep moving to reach your goal!"
        case .waterReminder(let current, let goal):
            return "You're at \(current)/\(goal) glasses today. Drink a glass of water now!"
        case .workoutReminder:
            return "Don't forget to complete your workout today!"
        case .foodLogReminder:
            return "Remember to log your meals today to stay on top of your nutrition goals."
        case .streakReminder:
            return "You haven't logged today yet. Stay on track with your nutrition goals!"
        case .healthNewsUpdate(let headline):
            return headline
        case .healthQuote(let quote):
            return quote
        case .favoriteAdded(_, let itemSubtitle):
            return itemSubtitle
        case .scanComplete(let itemName):
            return "Nutrition info for \"\(itemName)\" is ready to view."
        }
    }
}
