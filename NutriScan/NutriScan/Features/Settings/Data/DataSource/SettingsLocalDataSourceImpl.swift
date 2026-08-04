//
//  SettingsLocalDataSourceImpl.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

final class SettingsLocalDataSourceImpl: SettingsLocalDataSourceProtocol {
    private let appearanceKey = "appAppearance"
    private let languageKey = "appLanguage"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func getAppearanceRawValue() -> String? {
        defaults.string(forKey: appearanceKey)
    }

    func saveAppearanceRawValue(_ value: String) {
        defaults.set(value, forKey: appearanceKey)
    }

    func getLanguageRawValue() -> String? {
        defaults.string(forKey: languageKey)
    }

    func saveLanguageRawValue(_ value: String) {
        defaults.set(value, forKey: languageKey)
    }
}
