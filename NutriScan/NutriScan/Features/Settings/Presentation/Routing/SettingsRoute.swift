//
//  SettingsRoute.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import SwiftUI

enum SettingsRoute: Route {
    case profileSettings
    case termsAndConditions
    case help
    
    @MainActor @ViewBuilder
    var destination: some View {
        switch self {
        case .profileSettings:
            EditProfileView()
        case .termsAndConditions:
            SettingsFactory.makeTermsScreen()
        case .help:
            SettingsFactory.makeHelpScreen()
        }
    }
}
