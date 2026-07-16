//
//  UpdateProfileRequest.swift
//  NutriScan
//
//  Created by Osama Hosam on 16/07/2026.
//

// PATCH /v1/users/profile
struct UpdateProfileRequest: Codable {
    var firstName: String? = nil
    var lastName: String? = nil
    var dateOfBirth: String? = nil // YYYY-MM-DD
    var gender: String? = nil
    var heightCm: Int? = nil
    var weightKg: Int? = nil
    var allergyIds: [Int]? = nil
    var diseaseIds: [Int]? = nil
}
