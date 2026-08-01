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
    func isMuted(category: String) -> Bool
    func setMuted(_ muted: Bool, category: String)
    // Returns the full set of currently muted categories
    func mutedCategories() -> Set<String>
}

// MARK: - Implementation

final class NotificationMuteStore: NotificationMuteStoreProtocol {

    private let defaults: UserDefaults
    private let key = "NutriScan.mutedNotificationCategories"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func isMuted(category: String) -> Bool {
        mutedCategories().contains(category)
    }

    func setMuted(_ muted: Bool, category: String) {
        var current = mutedCategories()
        if muted {
            current.insert(category)
        } else {
            current.remove(category)
        }
        defaults.set(Array(current), forKey: key)
    }

    func mutedCategories() -> Set<String> {
        let stored = defaults.stringArray(forKey: key) ?? []
        return Set(stored)
    }
}
