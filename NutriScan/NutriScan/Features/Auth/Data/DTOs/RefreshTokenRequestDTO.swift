//
//  RefreshTokenRequestDTO.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 22/07/2026.
//

import Foundation

struct RefreshTokenRequestDTO: Encodable {
    let refreshToken: String
    let grantType: String = "refresh_token"
    let clientId: String = "mobile-api"

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case grantType = "grant_type"
        case clientId = "client_id"
    }
}
