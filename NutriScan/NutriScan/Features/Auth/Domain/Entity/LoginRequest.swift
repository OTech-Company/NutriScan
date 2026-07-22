//
//  LoginRequest.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import Foundation

struct LoginRequest {
    let email: String
    let password: String
    
    func toDTO() -> LoginRequestDTO {
        return LoginRequestDTO(username: email, password: password)
    }
}
