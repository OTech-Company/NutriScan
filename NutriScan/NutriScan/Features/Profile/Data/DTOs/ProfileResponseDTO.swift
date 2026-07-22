//
//  ProfileResponseDTO.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

struct ProfileResponseDTO: Codable {
    let id: String
    let email: String
    let username: String
    let firstName: String
    let lastName: String
    let dateOfBirth: String? // Kept as String to handle "YYYY-MM-DD" safely before domain mapping
    let gender: String?
    let heightCm: Double?
    let weightKg: Double?
    let allergies: [ReferenceItemDTO]
    let diseases: [ReferenceItemDTO]
    let updatedAt: String?
}
