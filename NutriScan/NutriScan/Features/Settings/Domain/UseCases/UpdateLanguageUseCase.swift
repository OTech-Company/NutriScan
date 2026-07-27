//
//  UpdateLanguageUseCase.swift
//  NutriScan
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
