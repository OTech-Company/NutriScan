//
//  NotificationMuteStore.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//
//  Persists muted notification categories and quiet hours to UserDefaults.
//

import Foundation

// MARK: - Protocol

protocol NotificationMuteStoreProtocol {
    func isMuted(category: NotificationCategory) -> Bool
    func setMuted(_ muted: Bool, category: NotificationCategory)
    func mutedCategories() -> Set<NotificationCategory>

    // Quiet Hours (Defaults to 22:00 - 07:00)
    var isQuietHoursEnabled: Bool { get }
    func setQuietHoursEnabled(_ enabled: Bool)
    var quietHoursStart: Int { get }
    var quietHoursEnd: Int { get }
    func isWithinQuietHours(now: Date) -> Bool
    func setQuietHours(startHour: Int, endHour: Int)
}

// MARK: - Extension default parameter
extension NotificationMuteStoreProtocol {
    func isWithinQuietHours() -> Bool {
        isWithinQuietHours(now: Date())
    }
}

// MARK: - Implementation

final class NotificationMuteStore: NotificationMuteStoreProtocol {

    private let defaults: UserDefaults
    private let mutedKey = "NutriScan.mutedNotificationCategories"
    private let quietEnabledKey = "NutriScan.quietHoursEnabled"
    private let quietStartKey = "NutriScan.quietHoursStart"
    private let quietEndKey = "NutriScan.quietHoursEnd"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func isMuted(category: NotificationCategory) -> Bool {
        mutedCategories().contains(category)
    }

    func setMuted(_ muted: Bool, category: NotificationCategory) {
        var current = mutedCategories()
        if muted {
            current.insert(category)
        } else {
            current.remove(category)
        }
        let rawValues = current.map { $0.rawValue }
        defaults.set(rawValues, forKey: mutedKey)
    }

    func mutedCategories() -> Set<NotificationCategory> {
        let stored = defaults.stringArray(forKey: mutedKey) ?? []
        let categories = stored.compactMap { NotificationCategory(rawValue: $0) }
        return Set(categories)
    }

    // MARK: - Quiet Hours

    var isQuietHoursEnabled: Bool {
        defaults.object(forKey: quietEnabledKey) as? Bool ?? true
    }

    func setQuietHoursEnabled(_ enabled: Bool) {
        defaults.set(enabled, forKey: quietEnabledKey)
    }

    var quietHoursStart: Int {
        defaults.object(forKey: quietStartKey) as? Int ?? 22 // Default 10 PM
    }

    var quietHoursEnd: Int {
        defaults.object(forKey: quietEndKey) as? Int ?? 7 // Default 7 AM
    }

    func isWithinQuietHours(now: Date = Date()) -> Bool {
        guard isQuietHoursEnabled else { return false }

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let start = quietHoursStart
        let end = quietHoursEnd

        if start > end {
            // Overnight interval e.g. 22:00 -> 07:00
            return hour >= start || hour < end
        } else {
            // Same-day interval e.g. 13:00 -> 17:00
            return hour >= start && hour < end
        }
    }

    func setQuietHours(startHour: Int, endHour: Int) {
        defaults.set(startHour, forKey: quietStartKey)
        defaults.set(endHour, forKey: quietEndKey)
    }
}
