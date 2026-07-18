//
//  HomeRoute.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.

import SwiftUI

enum ProfileSetupRoute: Route {
    case healthProfile
    case birthdatePicker
    case weightPicker
    case heightPicker
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .birthdatePicker:
            birthdatePickerView()
        case .healthProfile:
            HealthProfileView()
        case .weightPicker:
            WeightPickerView()
        case .heightPicker:
            HeightPickerView()
        }
    }
}
