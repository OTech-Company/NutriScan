//
//  RegisterResponseDTO+Domain.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 19/07/2026.
//

import Foundation

// MARK: - Response DTO to Domain Mapper
extension RegisterResponseDTO {
    func toDomain() -> RegisterResult {
        return RegisterResult(
            message: message,
            requiresEmailVerification: requiresEmailVerification
        )
    }
}
