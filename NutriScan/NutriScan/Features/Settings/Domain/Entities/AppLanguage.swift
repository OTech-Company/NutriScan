//
//  AppLanguage.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import SwiftUI

// MARK: - App Language
enum AppLanguage: String, CaseIterable, CustomStringConvertible {
    case english = "En"
    case arabic  = "Ar"

    var description: String { rawValue }

    var locale: Locale {
        Locale(identifier: self == .arabic ? "ar" : "en")
    }

    var layoutDirection: LayoutDirection {
        self == .arabic ? .rightToLeft : .leftToRight
    }

    static var current: AppLanguage {
        guard let raw = UserDefaults.standard.string(forKey: "appLanguage"),
              let language = AppLanguage(rawValue: raw) else {
            return .english
        }
        return language
    }

    /// Resolves a String Catalog key using the in-app language (not device locale).
    static func localized(_ key: String.LocalizationValue) -> String {
        String(localized: key, locale: current.locale)
    }
}
