//
//  Profile.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

struct Profile {
    let id: String
    let email: String
    let username: String
    let firstName: String
    let lastName: String
    let dateOfBirth: Date?
    let gender: String?
    let heightCm: Double?
    let weightKg: Double?
    let allergies: [ReferenceItem]
    let diseases: [ReferenceItem]
    let updatedAt: Date?
}
