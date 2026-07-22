//
//  ForgotPasswordResponseDTO+Domain.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 21/07/2026.
//

import Foundation

extension ForgotPasswordResponseDTO {
    func toDomain() -> ForgotPasswordResult {
        return ForgotPasswordResult(
            message: message ?? "Password reset email sent"
        )
    }
}
