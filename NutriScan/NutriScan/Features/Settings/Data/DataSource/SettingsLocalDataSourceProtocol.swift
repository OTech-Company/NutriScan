//
//  SettingsLocalDataSourceProtocol.swift
//  NutriScan
//

import Foundation

// MARK: - Settings Local Data Source Protocol
protocol SettingsLocalDataSourceProtocol {
    func getAppearanceRawValue() -> String?
    func saveAppearanceRawValue(_ value: String)
    func getLanguageRawValue() -> String?
    func saveLanguageRawValue(_ value: String)
}
