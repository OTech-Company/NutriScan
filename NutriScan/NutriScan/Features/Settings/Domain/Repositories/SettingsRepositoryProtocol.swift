//
//  SettingsRepositoryProtocol.swift
//  NutriScan
//

import Foundation

// MARK: - Settings Repository Protocol
protocol SettingsRepositoryProtocol {
    func getAppearance() -> AppAppearance
    func setAppearance(_ appearance: AppAppearance)
    func getLanguage() -> AppLanguage
    func setLanguage(_ language: AppLanguage)
}
