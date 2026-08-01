//
//  AppNotification.swift
//  NutriScan

//  Created by Ahmed Nageh on 01/08/2026.

import UserNotifications

enum AppNotification: LocalNotification {

    case favoriteAdded(itemTitle: String, itemSubtitle: String)
    case streakReminder
    case scanComplete(itemName: String)

    // MARK: - identifier

    var identifier: String {
        switch self {
        case .favoriteAdded(let itemTitle, _):
            return "favoriteAdded-\(itemTitle.lowercased().replacingOccurrences(of: " ", with: "_"))"
        case .streakReminder:
            return "streakReminder"
        case .scanComplete(let itemName):
            return "scanComplete-\(itemName.lowercased().replacingOccurrences(of: " ", with: "_"))"
        }
    }

    // MARK: - category (stable per case, used for muting)

    var category: NotificationCategory {
        switch self {
        case .favoriteAdded:    return .scanReminders
        case .streakReminder:   return .streak
        case .scanComplete:     return .scanReminders
        }
    }

    // MARK: - Content

    var title: String {
        switch self {
        case .favoriteAdded(let itemTitle, _):
            return "Added to Favorites 🌟"
        case .streakReminder:
            return "Keep Your Streak Going! 🔥"
        case .scanComplete(let itemName):
            return "Scan Complete ✅"
        }
    }

    var subtitle: String? {
        switch self {
        case .favoriteAdded(let itemTitle, _):
            return itemTitle
        case .streakReminder:
            return nil
        case .scanComplete(let itemName):
            return itemName
        }
    }

    var body: String {
        switch self {
        case .favoriteAdded(_, let itemSubtitle):
            return itemSubtitle
        case .streakReminder:
            return "You haven't logged today yet. Stay on track with your nutrition goals!"
        case .scanComplete(let itemName):
            return "Nutrition info for \"\(itemName)\" is ready to view."
        }
    }
}
