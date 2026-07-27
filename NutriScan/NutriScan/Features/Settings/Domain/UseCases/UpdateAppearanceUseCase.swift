//
//  UpdateAppearanceUseCase.swift
//  NutriScan
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
