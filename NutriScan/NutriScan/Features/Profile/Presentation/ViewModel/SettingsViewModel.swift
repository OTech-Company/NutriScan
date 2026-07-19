//
//  SettingsViewModel.swift
//  NutriScan
//

import Foundation
import Observation

@Observable
final class SettingsViewModel {
    var selectedAppearance: AppAppearance = .system
    var selectedLanguage: AppLanguage = .english

    func logout() {
        // TODO: Implement logout logic (clear keychain, reset flow coordinator)
    }
}
