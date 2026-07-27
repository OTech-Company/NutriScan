//
//  RegisterUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 19/07/2026.
//

import Foundation

protocol RegisterUseCaseProtocol {
    func execute(request: RegisterRequest) async throws -> RegisterResult
}

final class RegisterUseCase: RegisterUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol = AuthRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: RegisterRequest) async throws -> RegisterResult {
        return try await repository.register(request: request)
    }
}
