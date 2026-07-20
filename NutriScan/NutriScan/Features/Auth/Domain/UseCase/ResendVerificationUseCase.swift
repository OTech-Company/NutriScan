//
//  ResendVerificationUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import Foundation

final class ResendVerificationUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol = AuthRepositoryImpl()) {
        self.repository = repository
    }

    func execute(email: String) async throws -> ResendVerificationResult {
        return try await repository.resendVerification(email: email)
    }
}
