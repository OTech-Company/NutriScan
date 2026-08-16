//
//  ProfileSetupGender.swift
//  NutriScan
//

import Foundation

enum ProfileSetupGender: String, CaseIterable {
    case male = "MALE"
    case female = "FEMALE"

    var title: String {
        switch self {
        case .male: return LocalizationKeys.ProfileSetup.male.localized
        case .female: return LocalizationKeys.ProfileSetup.female.localized
        }
    }
}
