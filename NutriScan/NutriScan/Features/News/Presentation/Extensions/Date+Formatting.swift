//
//  Date+Formatting.swift
//  NewsFeed (Feature)
//
//  Presentation-only formatting concern — kept out of Domain so Article
//  stays a plain data model with no display logic attached.
//

import Foundation

extension Date {
    /// e.g. "3h ago", "2d ago", "Jul 20"
    var relativeShortString: String {
        let now = Date()
        let seconds = now.timeIntervalSince(self)

        if seconds < 60 {
            return "Just now"
        }
        let minutes = Int(seconds / 60)
        if minutes < 60 {
            return "\(minutes)m ago"
        }
        let hours = Int(seconds / 3600)
        if hours < 24 {
            return "\(hours)h ago"
        }
        let days = Int(seconds / 86400)
        if days < 7 {
            return "\(days)d ago"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
}
