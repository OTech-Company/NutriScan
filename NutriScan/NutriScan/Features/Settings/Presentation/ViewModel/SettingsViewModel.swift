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
        getAppearanceUseCase: GetAppearanceUseCaseProtocol,
        updateAppearanceUseCase: UpdateAppearanceUseCaseProtocol,
        getLanguageUseCase: GetLanguageUseCaseProtocol,
        updateLanguageUseCase: UpdateLanguageUseCaseProtocol
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
