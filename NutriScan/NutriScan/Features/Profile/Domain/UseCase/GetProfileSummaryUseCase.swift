//
//  GetProfileSummaryUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

final class GetProfileSummaryUseCase: GetProfileSummaryUseCaseProtocol {
    private let repository: ProfileSummaryRepositoryProtocol

    init(repository: ProfileSummaryRepositoryProtocol = DIContainer.shared.resolve(type: ProfileSummaryRepositoryProtocol.self)) {
        self.repository = repository
    }

    func execute() async throws -> ProfileSummary {
        try await repository.getProfileSummary()
    }
}
