//
//  ProfileInfo.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

struct ProfileInfo: Identifiable, Equatable {
    let id: String
    let email: String
    let username: String
    let firstName: String
    let lastName: String
    let dailyStreak: Int
    var imageUrl: String?
    let dateOfBirth: Date?
    let gender: String?
    let heightCm: Double?
    let weightKg: Double?
    let bmi: Double?
    let tdee: Double?
    let allergies: [ReferenceItem]
    let diseases: [ReferenceItem]
    var familyMembers: [FamilyMember]
    let updatedAt: Date?
    
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
