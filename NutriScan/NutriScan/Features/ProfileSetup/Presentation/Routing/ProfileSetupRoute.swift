//
//  HomeRoute.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.

import SwiftUI

enum ProfileSetupRoute: Route {
    case healthProfile

    @ViewBuilder
    var destination: some View {
        switch self {
        case .healthProfile:
            HealthProfileSetupView()

        }
    }
}
