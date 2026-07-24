//
//  ProfileSetupUserProfile.swift
//  NutriScan
//

import Foundation

struct ProfileSetupUserProfile {
    let firstName: String
    let lastName: String
    let dateOfBirth: Date
    let gender: ProfileSetupGender
    let heightCm: Int
    let weightKg: Int
    let allergies: [ProfileSetupAllergyOption]
    let diseases: [ProfileSetupDiseaseOption]
}
