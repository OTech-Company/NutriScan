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
    case caloriesHistory
    case scanDetail(scanId: String)
    
    @MainActor @ViewBuilder
    var destination: some View {
        switch self {
        case .personalInformation:
            PersonalInformationView()
        case .editProfile:
            EditProfileView()
        case .settings:
            SettingsFactory.makeSettingsView()
        case .scanHistory:
            ScanHistoryFactory.makeScanHistoryView()
        case .caloriesHistory:
            CaloriesHistoryFactory.makeView()
        case .scanDetail(let scanId):
            ProductDetailsScreen(scanId: scanId)
        }
    }
}
