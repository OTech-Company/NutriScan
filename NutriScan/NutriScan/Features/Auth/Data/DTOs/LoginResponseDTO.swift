//
//  LoginResponseDTO.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import Foundation

struct LoginResponseDTO: Decodable {
    let accessToken: String
    let expiresIn: Int
    let refreshExpiresIn: Int
    let refreshToken: String
    let tokenType: String
    let notBeforePolicy: Int
    let sessionState: String
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshExpiresIn = "refresh_expires_in"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case notBeforePolicy = "not-before-policy"
        case sessionState = "session_state"
        case scope
    }
}
