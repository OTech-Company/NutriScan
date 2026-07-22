//
//  AuthRemoteService.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 19/07/2026.
//

import Foundation

protocol AuthRemoteServiceProtocol {
    func register(_ dto: RegisterRequestDTO) async throws -> RegisterResponseDTO
    func resendVerification(_ dto: ResendVerificationRequestDTO) async throws -> ResendVerificationResponseDTO
    func login(_ dto: LoginRequestDTO) async throws -> LoginResponseDTO
    func forgotPassword(_ dto: ForgotPasswordRequestDTO) async throws -> ForgotPasswordResponseDTO
}

final class AuthRemoteService: AuthRemoteServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func register(_ dto: RegisterRequestDTO) async throws -> RegisterResponseDTO {
        return try await networkService.request(AuthEndpoint.register(dto))
    }

    func resendVerification(_ dto: ResendVerificationRequestDTO) async throws -> ResendVerificationResponseDTO {
        do {
            return try await networkService.request(AuthEndpoint.resendVerification(dto))
        } catch NetworkError.decodingFailed {
            // If the server returns empty content, return a default response model
            return ResendVerificationResponseDTO(message: "Verification email resent successfully.")
        }
    }

    func login(_ dto: LoginRequestDTO) async throws -> LoginResponseDTO {
        return try await networkService.request(AuthEndpoint.login(dto))
    }

    func forgotPassword(_ dto: ForgotPasswordRequestDTO) async throws -> ForgotPasswordResponseDTO {
        return try await networkService.request(AuthEndpoint.forgotPassword(dto))
    }
}
