//
//  NotificationHistoryItem.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

struct NotificationHistoryItem: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let body: String
    let category: NotificationCategory
    let timestamp: Date
    var isRead: Bool

    init(
        id: UUID = UUID(),
        title: String,
        body: String,
        category: NotificationCategory,
        timestamp: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.category = category
        self.timestamp = timestamp
        self.isRead = isRead
    }

    /// Formats relative time string e.g. "1 hr ago", "3 hr ago", "Just now"
    var relativeTimeString: String {
        let now = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day], from: timestamp, to: now)

        if let day = components.day, day > 0 {
            return day == 1 ? "1 day ago" : "\(day) days ago"
        }
        if let hour = components.hour, hour > 0 {
            return "\(hour) hr ago"
        }
        if let minute = components.minute, minute > 0 {
            return "\(minute) min ago"
        }
        return "Just now"
    }
}
