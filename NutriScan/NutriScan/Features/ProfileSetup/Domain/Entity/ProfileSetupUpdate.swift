//
//  ProfileSetupUpdate.swift
//  NutriScan
//

import Foundation

struct ProfileSetupUpdate {
    var firstName: String?
    var lastName: String?
    var dateOfBirth: Date?
    var gender: ProfileSetupGender?
    var heightCm: Int?
    var weightKg: Int?
    var allergyIds: [Int]?
    var diseaseIds: [Int]?
}
