//
//  SettingsFactory.swift
//  NutriScan
//

import SwiftUI

@MainActor
final class SettingsFactory {
    static func makeSettingsView() -> SettingsView {
        let viewModel = SettingsViewModel()
        return SettingsView(viewModel: viewModel)
    }

    static func makeHelpScreen() -> HelpScreen {
        let viewModel = HelpViewModel()
        return HelpScreen(viewModel: viewModel)
    }
}
