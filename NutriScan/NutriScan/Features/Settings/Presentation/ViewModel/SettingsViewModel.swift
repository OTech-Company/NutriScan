//
//  SettingsViewModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation
import Observation

@Observable
final class SettingsViewModel {
    private let getAppearanceUseCase: GetAppearanceUseCaseProtocol
    private let updateAppearanceUseCase: UpdateAppearanceUseCaseProtocol
    private let getLanguageUseCase: GetLanguageUseCaseProtocol
    private let updateLanguageUseCase: UpdateLanguageUseCaseProtocol
    private let deleteAccountUseCase: DeleteAccountUseCaseProtocol

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
    var showDeleteAccountAlert: Bool = false
    var isDeletingAccount: Bool = false
    var deleteError: String? = nil

    init(
        getAppearanceUseCase: GetAppearanceUseCaseProtocol,
        updateAppearanceUseCase: UpdateAppearanceUseCaseProtocol,
        getLanguageUseCase: GetLanguageUseCaseProtocol,
        updateLanguageUseCase: UpdateLanguageUseCaseProtocol,
        deleteAccountUseCase: DeleteAccountUseCaseProtocol
    ) {
        self.getAppearanceUseCase = getAppearanceUseCase
        self.updateAppearanceUseCase = updateAppearanceUseCase
        self.getLanguageUseCase = getLanguageUseCase
        self.updateLanguageUseCase = updateLanguageUseCase
        self.deleteAccountUseCase = deleteAccountUseCase

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

    func requestDeleteAccount() {
        showDeleteAccountAlert = true
    }

    func cancelDeleteAccount() {
        showDeleteAccountAlert = false
    }

    @MainActor
    func confirmDeleteAccount(flowCoordinator: AppFlowCoordinator) async {
        showDeleteAccountAlert = false
        isDeletingAccount = true
        deleteError = nil
        defer { isDeletingAccount = false }

        do {
            _ = try await deleteAccountUseCase.execute()
            flowCoordinator.logout()
        } catch {
            deleteError = error.localizedDescription
        }
    }
}

