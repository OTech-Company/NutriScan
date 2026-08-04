//
//  UpdateAppearanceUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

protocol UpdateAppearanceUseCaseProtocol {
    func execute(_ appearance: AppAppearance)
}

final class UpdateAppearanceUseCase: UpdateAppearanceUseCaseProtocol {
    private let repository: SettingsRepositoryProtocol

    init(repository: SettingsRepositoryProtocol = DIContainer.shared.resolve(type: SettingsRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute(_ appearance: AppAppearance) {
        repository.setAppearance(appearance)
    }
}
