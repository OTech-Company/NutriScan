//
//  SettingsViewModel.swift
//  NutriScan
//

import Foundation
import Observation

@Observable
final class SettingsViewModel {
    private let getAppearanceUseCase: GetAppearanceUseCaseProtocol
    private let updateAppearanceUseCase: UpdateAppearanceUseCaseProtocol
    private let getLanguageUseCase: GetLanguageUseCaseProtocol
    private let updateLanguageUseCase: UpdateLanguageUseCaseProtocol

    var selectedAppearance: AppAppearance {
        didSet {
            updateAppearanceUseCase.execute(selectedAppearance)
        }
    }

    var selectedLanguage: AppLanguage {
        didSet {
            updateLanguageUseCase.execute(selectedLanguage)
        }
    }

    var showLogoutAlert: Bool = false

    init(
        getAppearanceUseCase: GetAppearanceUseCaseProtocol = DIContainer.shared.resolve(type: GetAppearanceUseCaseProtocol.self),
        updateAppearanceUseCase: UpdateAppearanceUseCaseProtocol = DIContainer.shared.resolve(type: UpdateAppearanceUseCaseProtocol.self),
        getLanguageUseCase: GetLanguageUseCaseProtocol = DIContainer.shared.resolve(type: GetLanguageUseCaseProtocol.self),
        updateLanguageUseCase: UpdateLanguageUseCaseProtocol = DIContainer.shared.resolve(type: UpdateLanguageUseCaseProtocol.self)
    ) {
        self.getAppearanceUseCase = getAppearanceUseCase
        self.updateAppearanceUseCase = updateAppearanceUseCase
        self.getLanguageUseCase = getLanguageUseCase
        self.updateLanguageUseCase = updateLanguageUseCase

        self.selectedAppearance = getAppearanceUseCase.execute()
        self.selectedLanguage = getLanguageUseCase.execute()
    }

    func requestLogout() {
        showLogoutAlert = true
    }

    func confirmLogout(flowCoordinator: AppFlowCoordinator) {
        showLogoutAlert = false
        flowCoordinator.logout()
    }

    func cancelLogout() {
        showLogoutAlert = false
    }
}
