//
//  AuthRepositoryImpl.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 19/07/2026.
//

import Foundation

final class AuthRepositoryImpl: AuthRepositoryProtocol {
    private let remoteService: AuthRemoteServiceProtocol

    init(remoteService: AuthRemoteServiceProtocol = AuthRemoteService()) {
        self.remoteService = remoteService
    }

    func register(request: RegisterRequest) async throws -> RegisterResult {
        let dto = request.toDTO()
        let response = try await remoteService.register(dto)
        return response.toDomain()
    }
}
