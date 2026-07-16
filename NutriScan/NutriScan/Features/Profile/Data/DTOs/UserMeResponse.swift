//
//  UserMeResponse.swift
//  NutriScan
//
//  Created by Osama Hosam on 16/07/2026.
//

// GET /v1/users/me
struct UserMeResponse: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let username: String
}
