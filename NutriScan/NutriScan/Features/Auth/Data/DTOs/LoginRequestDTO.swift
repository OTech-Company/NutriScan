//
//  LoginRequestDTO.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let username: String
    let password: String
    let grantType: String = "password"
    let clientId: String = "mobile-api"

    enum CodingKeys: String, CodingKey {
        case username
        case password
        case grantType = "grant_type"
        case clientId = "client_id"
    }
}