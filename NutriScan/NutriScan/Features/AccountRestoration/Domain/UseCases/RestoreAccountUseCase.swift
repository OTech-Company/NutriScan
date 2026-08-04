//
//  RestoreAccountUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

protocol RestoreAccountUseCaseProtocol {
    func execute() async throws -> RestoreAccountResult
}

final class RestoreAccountUseCase: RestoreAccountUseCaseProtocol {
    private let repository: AccountRestorationRepositoryProtocol

    init(repository: AccountRestorationRepositoryProtocol = DIContainer.shared.resolve(type: AccountRestorationRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute() async throws -> RestoreAccountResult {
        try await repository.restoreAccount()
    }
}
