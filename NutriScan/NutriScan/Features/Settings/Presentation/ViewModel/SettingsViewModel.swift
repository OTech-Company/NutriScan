//
//  SettingsViewModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation
import Observation

enum SettingsAlertDestination: String, Identifiable {
    case logout
    case deleteAccount
    var id: String { rawValue }
}

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

    var alert: SettingsAlertDestination?
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
        alert = .logout
    }

    func confirmLogout(flowCoordinator: AppFlowCoordinator) {
        alert = nil
        flowCoordinator.logout()
    }

    func cancelLogout() {
        alert = nil
    }

    func requestDeleteAccount() {
        alert = .deleteAccount
    }

    func cancelDeleteAccount() {
        alert = nil
    }

    @MainActor
    func confirmDeleteAccount(flowCoordinator: AppFlowCoordinator) async {
        alert = nil
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
