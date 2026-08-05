//
//  GetAppearanceUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

protocol GetAppearanceUseCaseProtocol {
    func execute() -> AppAppearance
}

final class GetAppearanceUseCase: GetAppearanceUseCaseProtocol {
    private let repository: SettingsRepositoryProtocol

    init(repository: SettingsRepositoryProtocol = DIContainer.shared.resolve(type: SettingsRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute() -> AppAppearance {
        repository.getAppearance()
    }
}
