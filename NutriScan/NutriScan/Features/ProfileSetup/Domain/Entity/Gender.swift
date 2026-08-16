//
//  Gender.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 17/07/2026.
//

enum Gender: String, CaseIterable {
    case male
    case female

    var title: String {
        switch self {
        case .male: return LocalizationKeys.ProfileSetup.male.localized
        case .female: return LocalizationKeys.ProfileSetup.female.localized
        }
    }
}
