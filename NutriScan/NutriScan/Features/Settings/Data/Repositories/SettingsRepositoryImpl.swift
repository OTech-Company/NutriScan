//
//  SettingsRepositoryImpl.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

final class SettingsRepositoryImpl: SettingsRepositoryProtocol {
    private let localDataSource: SettingsLocalDataSourceProtocol
    private let networkService: NetworkServiceProtocol

    init(
        localDataSource: SettingsLocalDataSourceProtocol,
        networkService: NetworkServiceProtocol = NetworkService.shared
    ) {
        self.localDataSource = localDataSource
        self.networkService = networkService
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

    func deleteAccount() async throws -> DeleteAccountResult {
        let dto: DeleteAccountResponseDTO = try await networkService.request(SettingsEndpoint.deleteAccount)
        return dto.toDomain()
    }
}

