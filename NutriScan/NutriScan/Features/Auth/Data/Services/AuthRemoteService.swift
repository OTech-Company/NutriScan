//
//  AuthRemoteService.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 19/07/2026.
//

import Foundation

protocol AuthRemoteServiceProtocol {
    func register(_ dto: RegisterRequestDTO) async throws -> RegisterResponseDTO
}

final class AuthRemoteService: AuthRemoteServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func register(_ dto: RegisterRequestDTO) async throws -> RegisterResponseDTO {
        return try await networkService.request(AuthEndpoint.register(dto))
    }
}
