//
//  SettingsRoute.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import SwiftUI

enum SettingsRoute: Route {
    case profileSettings
    case appearance
    case language
    case termsAndConditions
    case help
    case notificationSettings
    
    @MainActor @ViewBuilder
    var destination: some View {
        switch self {
        case .profileSettings:
            // TODO: Replace with actual Profile Settings View
            Text("Profile Settings (Placeholder)")
        case .appearance:
            // TODO: Replace with actual Appearance View
            Text("Appearance (Placeholder)")
        case .language:
            // TODO: Replace with actual Language View
            Text("Language (Placeholder)")
        case .termsAndConditions:
            // TODO: Replace with actual Terms View
            Text("Terms & Conditions (Placeholder)")
        case .help:
            HelpScreen()
        case .notificationSettings:
            NotificationSettingsFactory.makeNotificationSettingsView()
        }
    }
}
