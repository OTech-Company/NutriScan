//
//  AccountRestorationRepositoryImpl.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

final class AccountRestorationRepositoryImpl: AccountRestorationRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func restoreAccount() async throws -> RestoreAccountResult {
        let dto: RestoreAccountResponseDTO = try await networkService.request(AccountRestorationEndpoint.restoreAccount)
        return dto.toDomain()
    }
}
