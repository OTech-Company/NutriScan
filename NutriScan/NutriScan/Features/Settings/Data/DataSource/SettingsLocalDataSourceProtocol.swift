//
//  SettingsLocalDataSourceProtocol.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

// MARK: - Settings Local Data Source Protocol
protocol SettingsLocalDataSourceProtocol {
    func getAppearanceRawValue() -> String?
    func saveAppearanceRawValue(_ value: String)
    func getLanguageRawValue() -> String?
    func saveLanguageRawValue(_ value: String)
}
