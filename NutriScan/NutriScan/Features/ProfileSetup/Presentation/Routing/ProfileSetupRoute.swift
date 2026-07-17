//
//  HomeRoute.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.

import SwiftUI

enum ProfileSetupRoute: Route {

    case birthdatePicker

    @ViewBuilder
    var destination: some View {
        switch self {
        case .birthdatePicker:
            birthdatePickerView()
        }
    }
}
