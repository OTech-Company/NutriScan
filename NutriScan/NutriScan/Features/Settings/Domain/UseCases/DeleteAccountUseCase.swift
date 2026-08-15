//
//  DeleteAccountUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

protocol DeleteAccountUseCaseProtocol {
    func execute() async throws -> DeleteAccountResult
}

final class DeleteAccountUseCase: DeleteAccountUseCaseProtocol {
    private let repository: SettingsRepositoryProtocol

    init(repository: SettingsRepositoryProtocol = DIContainer.shared.resolve(type: SettingsRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute() async throws -> DeleteAccountResult {
        try await repository.deleteAccount()
    }
}
