//
//  SettingsRepositoryProtocol.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

// MARK: - Settings Repository Protocol
protocol SettingsRepositoryProtocol {
    func getAppearance() -> AppAppearance
    func setAppearance(_ appearance: AppAppearance)
    func getLanguage() -> AppLanguage
    func setLanguage(_ language: AppLanguage)
    func deleteAccount() async throws -> DeleteAccountResult
}

