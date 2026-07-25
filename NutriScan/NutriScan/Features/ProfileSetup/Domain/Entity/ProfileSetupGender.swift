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
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}
