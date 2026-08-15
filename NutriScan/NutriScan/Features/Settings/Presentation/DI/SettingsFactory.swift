//
//  SettingsFactory.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import SwiftUI

@MainActor
final class SettingsFactory {
    static func makeSettingsView() -> SettingsView {
        let viewModel = SettingsViewModel(
            getAppearanceUseCase: DIContainer.shared.resolve(type: GetAppearanceUseCaseProtocol.self),
            updateAppearanceUseCase: DIContainer.shared.resolve(type: UpdateAppearanceUseCaseProtocol.self),
            getLanguageUseCase: DIContainer.shared.resolve(type: GetLanguageUseCaseProtocol.self),
            updateLanguageUseCase: DIContainer.shared.resolve(type: UpdateLanguageUseCaseProtocol.self),
            deleteAccountUseCase: DIContainer.shared.resolve(type: DeleteAccountUseCaseProtocol.self)
        )
        return SettingsView(viewModel: viewModel)
    }

    static func makeHelpScreen() -> HelpScreen {
        let viewModel = HelpViewModel(
            getFaqUseCase: DIContainer.shared.resolve(type: GetFaqUseCaseProtocol.self)
        )
        return HelpScreen(viewModel: viewModel)
    }

    static func makeTermsScreen() -> TermsScreen {
        let viewModel = TermsViewModel(
            getTermsUseCase: DIContainer.shared.resolve(type: GetTermsUseCaseProtocol.self)
        )
        return TermsScreen(viewModel: viewModel)
    }
}
