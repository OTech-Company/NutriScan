//
//  SettingsRepositoryImpl.swift
//  NutriScan
//

import Foundation

final class SettingsRepositoryImpl: SettingsRepositoryProtocol {
    private let localDataSource: SettingsLocalDataSourceProtocol

    init(localDataSource: SettingsLocalDataSourceProtocol) {
        self.localDataSource = localDataSource
    }

    func getAppearance() -> AppAppearance {
        guard let raw = localDataSource.getAppearanceRawValue(),
              let value = AppAppearance(rawValue: raw) else { return .system }
        return value
    }

    func setAppearance(_ appearance: AppAppearance) {
        localDataSource.saveAppearanceRawValue(appearance.rawValue)
    }

    func getLanguage() -> AppLanguage {
        guard let raw = localDataSource.getLanguageRawValue(),
              let value = AppLanguage(rawValue: raw) else { return .english }
        return value
    }

    func setLanguage(_ language: AppLanguage) {
        localDataSource.saveLanguageRawValue(language.rawValue)
    }
}
