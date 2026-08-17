//
//  AppConstants.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 25/07/2026.
//

import Foundation

public enum AppConstants {
    public static let defaultUserAvatarURL = "https://img.magnific.com/free-photo/low-angle-close-up-shot-man-looking-away_23-2148194050.jpg?semt=ais_hybrid&w=740&q=80"
}

protocol DailyTrackingDayProviding {
    var calendar: Calendar { get }

    func dateIdentifier(for date: Date) -> String
    func date(from identifier: String) -> Date?
    func dayInterval(for identifier: String) -> DateInterval?
    func nextDayBoundary(after date: Date) -> Date?
}

struct ServerDailyTrackingDayProvider: DailyTrackingDayProviding {
    private static let serverTimeZone = TimeZone(secondsFromGMT: 2 * 60 * 60)!

    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = Self.serverTimeZone
        return calendar
    }

    func dateIdentifier(for date: Date) -> String {
        formatter.string(from: date)
    }

    func date(from identifier: String) -> Date? {
        guard let date = formatter.date(from: identifier),
              formatter.string(from: date) == identifier else { return nil }
        return date
    }

    func dayInterval(for identifier: String) -> DateInterval? {
        guard let date = date(from: identifier) else { return nil }
        return calendar.dateInterval(of: .day, for: date)
    }

    func nextDayBoundary(after date: Date) -> Date? {
        let startOfDay = calendar.startOfDay(for: date)
        return calendar.date(byAdding: .day, value: 1, to: startOfDay)
    }

    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = Self.serverTimeZone
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.isLenient = false
        return formatter
    }
}
