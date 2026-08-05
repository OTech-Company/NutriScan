//
//  UpdateLanguageUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

protocol UpdateLanguageUseCaseProtocol {
    func execute(_ language: AppLanguage)
}

final class UpdateLanguageUseCase: UpdateLanguageUseCaseProtocol {
    private let repository: SettingsRepositoryProtocol

    init(repository: SettingsRepositoryProtocol = DIContainer.shared.resolve(type: SettingsRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute(_ language: AppLanguage) {
        repository.setLanguage(language)
    }
}
