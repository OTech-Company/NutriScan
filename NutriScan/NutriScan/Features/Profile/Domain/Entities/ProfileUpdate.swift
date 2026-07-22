//
//  ProfileUpdate.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

struct ProfileUpdate {
    let firstName: String
    let lastName: String
    let dateOfBirth: Date
    let gender: String
    let heightCm: Double
    let weightKg: Double
    let allergyIds: [Int]
    let diseaseIds: [Int]
}
