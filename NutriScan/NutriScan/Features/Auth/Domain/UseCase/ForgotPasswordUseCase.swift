//
//  ForgotPasswordUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 21/07/2026.
//

import Foundation

protocol ForgotPasswordUseCaseProtocol {
    func execute(email: String) async throws -> ForgotPasswordResult
}

final class ForgotPasswordUseCase: ForgotPasswordUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol = AuthRepositoryImpl()) {
        self.repository = repository
    }

    func execute(email: String) async throws -> ForgotPasswordResult {
        return try await repository.forgotPassword(email: email)
    }
}
