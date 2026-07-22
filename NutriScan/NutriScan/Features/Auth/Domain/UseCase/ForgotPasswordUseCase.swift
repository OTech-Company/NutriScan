//
//  ForgotPasswordUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 21/07/2026.
//

import Foundation

final class ForgotPasswordUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol = AuthRepositoryImpl()) {
        self.repository = repository
    }

    func execute(email: String) async throws -> ForgotPasswordResult {
        return try await repository.forgotPassword(email: email)
    }
}
