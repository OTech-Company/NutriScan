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
        case accessToken
        case expiresIn
        case refreshExpiresIn
        case refreshToken
        case tokenType
        case notBeforePolicy = "not-before-policy"
        case sessionState
        case scope
    }
}
