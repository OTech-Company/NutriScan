//
//  NotificationMuteStore.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//
//  Persists muted notification categories to UserDefaults.
//

import Foundation

// MARK: - Protocol

protocol NotificationMuteStoreProtocol {
    func isMuted(category: NotificationCategory) -> Bool
    func setMuted(_ muted: Bool, category: NotificationCategory)
    // Returns the full set of currently muted categories
    func mutedCategories() -> Set<NotificationCategory>
}

// MARK: - Implementation

final class NotificationMuteStore: NotificationMuteStoreProtocol {

    private let defaults: UserDefaults
    private let key = "NutriScan.mutedNotificationCategories"

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
        defaults.set(rawValues, forKey: key)
    }

    func mutedCategories() -> Set<NotificationCategory> {
        let stored = defaults.stringArray(forKey: key) ?? []
        let categories = stored.compactMap { NotificationCategory(rawValue: $0) }
        return Set(categories)
    }
}
