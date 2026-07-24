//
//  ProfileSetupResponseDTO.swift
//  NutriScan
//

import Foundation

struct ProfileSetupAllergyDTO: Decodable {
    let id: Int
    let name: String
}

struct ProfileSetupDiseaseDTO: Decodable {
    let id: Int
    let name: String
}

struct ProfileSetupResponseDTO: Decodable {
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    let gender: String
    let heightCm: Int
    let weightKg: Int
    let allergies: [ProfileSetupAllergyDTO]
    let diseases: [ProfileSetupDiseaseDTO]

    func toDomain() -> ProfileSetupUserProfile {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return ProfileSetupUserProfile(
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: formatter.date(from: dateOfBirth) ?? Date(),
            gender: ProfileSetupGender(rawValue: gender) ?? .male,
            heightCm: heightCm,
            weightKg: weightKg,
            allergies: allergies.map { ProfileSetupAllergyOption(id: $0.id, name: $0.name) },
            diseases: diseases.map { ProfileSetupDiseaseOption(id: $0.id, name: $0.name) }
        )
    }
}
