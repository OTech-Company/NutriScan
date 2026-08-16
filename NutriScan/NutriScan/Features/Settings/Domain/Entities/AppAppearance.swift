//
//  AppAppearance.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import SwiftUI

// MARK: - Appearance Mode
enum AppAppearance: String, CaseIterable, CustomStringConvertible {
    case system = "System"
    case dark   = "Dark"
    case light  = "Light"

    var description: String {
        switch self {
        case .system: return LocalizationKeys.Settings.appearanceSystem.localized
        case .light:  return LocalizationKeys.Settings.appearanceLight.localized
        case .dark:   return LocalizationKeys.Settings.appearanceDark.localized
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
