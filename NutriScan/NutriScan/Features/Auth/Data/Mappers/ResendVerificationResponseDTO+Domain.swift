//
//  ResendVerificationResponseDTO+Domain.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import Foundation

extension ResendVerificationResponseDTO {
    func toDomain() -> ResendVerificationResult {
        return ResendVerificationResult(
            message: message ?? "Verification email resent successfully."
        )
    }
}
