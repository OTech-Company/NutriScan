//
//  AppLanguage.swift
//  NutriScan
//

import Foundation

// MARK: - App Language
enum AppLanguage: String, CaseIterable, CustomStringConvertible {
    case english = "En"
    case arabic  = "Ar"

    var description: String { rawValue }
}
