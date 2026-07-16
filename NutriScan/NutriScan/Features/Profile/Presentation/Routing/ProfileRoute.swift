//
//  ProfileRoute.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

enum ProfileRoute: Route {
    case editProfile
    case settings
    case personalInformation
    case scanHistory
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .personalInformation:
            PersonalInformationView()
        case .editProfile:
            EditProfileView()
        case .settings:
            SettingsView()
        case .scanHistory:
            ScanHistoryView()
        }
    }
}
