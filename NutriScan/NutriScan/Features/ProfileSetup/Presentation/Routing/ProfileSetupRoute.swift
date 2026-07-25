//
//  HomeRoute.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.

import SwiftUI

enum ProfileSetupRoute: Route, Hashable, Equatable {
    case healthProfile(ProfileSetupFlowViewModel)

    static func == (lhs: ProfileSetupRoute, rhs: ProfileSetupRoute) -> Bool {
        switch (lhs, rhs) {
        case (.healthProfile(let lhsVm), .healthProfile(let rhsVm)):
            return lhsVm === rhsVm
        }
    }

    func hash(into hasher: inout Swift.Hasher) {
        switch self {
        case .healthProfile(let vm):
            hasher.combine(ObjectIdentifier(vm))
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .healthProfile(let viewModel):
            HealthProfileSetupView(viewModel: viewModel)

        }
    }
}
