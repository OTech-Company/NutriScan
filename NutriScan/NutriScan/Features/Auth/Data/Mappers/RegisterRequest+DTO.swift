//
//  RegisterRequest+DTO.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 19/07/2026.
//

import Foundation

// MARK: - Request Domain to DTO Mapper
extension RegisterRequest {
    func toDTO() -> RegisterRequestDTO {
        return RegisterRequestDTO(
            firstName: firstName,
            lastName: lastName,
            email: email,
            username: username,
            password: password,
            allergies: []
        )
    }
}
