//
//  ProfileSetupUpdateDTO.swift
//  NutriScan
//

import Foundation

struct ProfileSetupUpdateDTO: Encodable {
    let firstName: String?
    let lastName: String?
    let dateOfBirth: String?
    let gender: String?
    let heightCm: Int?
    let weightKg: Int?
    let allergyIds: [Int]?
    let diseaseIds: [Int]?

    init(domain: ProfileSetupUpdate) {
        firstName = domain.firstName
        lastName = domain.lastName
        if let dob = domain.dateOfBirth {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone(identifier: "UTC")
            dateOfBirth = formatter.string(from: dob)
        } else {
            dateOfBirth = nil
        }
        gender = domain.gender?.rawValue
        heightCm = domain.heightCm
        weightKg = domain.weightKg
        allergyIds = domain.allergyIds
        diseaseIds = domain.diseaseIds
    }
}
