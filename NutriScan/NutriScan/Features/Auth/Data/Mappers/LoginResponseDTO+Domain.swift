//
//  LoginResponseDTO+Domain.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import Foundation

extension LoginResponseDTO {
    func toDomain() -> LoginResult {
        return LoginResult(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresIn: expiresIn
        )
    }
}
