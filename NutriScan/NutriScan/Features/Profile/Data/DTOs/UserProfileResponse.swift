//
//  UserProfileResponse.swift
//  NutriScan
//
//  Created by Osama Hosam on 16/07/2026.
//

// GET /v1/users/profile
struct UserProfileResponse: Codable {
    let id: String
    let email: String
    let username: String
    let firstName: String?
    let lastName: String?
    let dateOfBirth: String? // YYYY-MM-DD
    let gender: String?
    let heightCm: Int?
    let weightKg: Int?
    let allergies: [AllergyDTO]?
    let diseases: [DiseaseDTO]?
    let updatedAt: String // ISO 8601 date string
}

struct AllergyDTO: Codable {
    let id: Int
    let name: String
}

struct DiseaseDTO: Codable {
    let id: Int
    let name: String
}


extension UserProfileResponse {
    func toDomain() -> UserProfile {
        let totalFields = 8
        var filledFields = 0
        
        if let first = firstName, !first.isEmpty { filledFields += 1 }
        if let last = lastName, !last.isEmpty { filledFields += 1 }
        if let dob = dateOfBirth, !dob.isEmpty { filledFields += 1 }
        if let gen = gender, !gen.isEmpty { filledFields += 1 }
        if let height = heightCm, height > 0 { filledFields += 1 }
        if let weight = weightKg, weight > 0 { filledFields += 1 }
        if let allergies = allergies, !allergies.isEmpty { filledFields += 1 }
        if let diseases = diseases, !diseases.isEmpty { filledFields += 1 }
        
        let percentage = Int((Double(filledFields) / Double(totalFields)) * 100)
        let constructedName = [firstName, lastName]
            .compactMap { $0 }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return UserProfile(
            fullName: constructedName.isEmpty ? "No Name Set" : constructedName,
            email: email,
            completionPercentage: percentage
        )
    }
}
