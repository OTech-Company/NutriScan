//
//  SharedProfileResponseDTO+Domain.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//
import Foundation
extension UserProfileResponseDTO {
    func toDomain() -> ProfileInfo {
        let dob: Date? = {
            guard let dateStr = dateOfBirth else { return nil }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: dateStr)
        }()
        
        let updateDate: Date? = {
            guard let dateStr = updatedAt else { return nil }
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter.date(from: dateStr)
        }()

        return ProfileInfo(
            id: id,
            email: email,
            username: username,
            firstName: firstName,
            lastName: lastName,
            dailyStreak: dailyStreak ?? 0,
            imageUrl: imageUrl,
            dateOfBirth: dob,
            gender: gender,
            heightCm: heightCm,
            weightKg: weightKg,
            bmi: bmi,
            tdee: tdee,
            allergies: allergies?.map { ReferenceItem(id: $0.id, name: $0.name) } ?? [],
            diseases: diseases?.map { ReferenceItem(id: $0.id, name: $0.name) } ?? [],
            familyMembers: familyMembers?.map { $0.toDomain() } ?? [],
            updatedAt: updateDate
        )
    }
}
