//
//  GetLanguageUseCase.swift
//  NutriScan
//

import Foundation

protocol GetLanguageUseCaseProtocol {
    func execute() -> AppLanguage
}

final class GetLanguageUseCase: GetLanguageUseCaseProtocol {
    private let repository: SettingsRepositoryProtocol

    init(repository: SettingsRepositoryProtocol = DIContainer.shared.resolve(type: SettingsRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute() -> AppLanguage {
        repository.getLanguage()
    }
}
