//
//  SettingsOptions.swift
//  NutriScan
//

import Foundation

// MARK: - Appearance Mode
enum AppAppearance: String, CaseIterable, CustomStringConvertible {
    case system = "System"
    case dark   = "Dark"
    case light  = "Light"

    var description: String { rawValue }
}

// MARK: - App Language
enum AppLanguage: String, CaseIterable, CustomStringConvertible {
    case english = "En"
    case arabic  = "Ar"

    var description: String { rawValue }
}
