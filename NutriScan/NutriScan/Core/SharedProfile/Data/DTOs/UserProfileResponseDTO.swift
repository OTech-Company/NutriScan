//
//  SharedProfileDTOs.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

struct UserProfileResponseDTO: Codable {
    let id: String
    let email: String
    let username: String
    let firstName: String
    let lastName: String
    let imageUrl: String?
    let dateOfBirth: String?
    let gender: String?
    let heightCm: Double?
    let weightKg: Double?
    let bmi: Double?
    let tdee: Double?
    let allergies: [ReferenceItemDTO]?
    let diseases: [ReferenceItemDTO]?
    let familyMembers: [UserFamilyMemberDTO]?
    let updatedAt: String?
}
