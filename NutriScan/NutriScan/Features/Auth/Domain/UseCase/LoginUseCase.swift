//
//  LoginUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import Foundation

final class LoginUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol = AuthRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: LoginRequest) async throws -> LoginResult {
        let result = try await repository.login(request: request)
        
        // Persist tokens securely in Keychain
        try KeychainManager.shared.save(key: "access_token", value: result.accessToken)
        try KeychainManager.shared.save(key: "refresh_token", value: result.refreshToken)
        
        return result
    }
}
