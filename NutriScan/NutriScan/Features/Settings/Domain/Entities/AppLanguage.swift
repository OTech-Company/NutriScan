//
//  AppLanguage.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

// MARK: - App Language
enum AppLanguage: String, CaseIterable, CustomStringConvertible {
    case english = "En"
    case arabic  = "Ar"

    var description: String { rawValue }
}
