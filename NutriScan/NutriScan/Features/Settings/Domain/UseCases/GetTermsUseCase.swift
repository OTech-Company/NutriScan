//
//  GetTermsUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

protocol GetTermsUseCaseProtocol {
    func execute() async throws -> [TermsItem]
}

struct GetTermsUseCase: GetTermsUseCaseProtocol {
    private let repository: TermsRepositoryProtocol

    init(
        repository: TermsRepositoryProtocol = DIContainer.shared.resolve(
            type: TermsRepositoryProtocol.self)
    ) {
        self.repository = repository
    }

    func execute() async throws -> [TermsItem] {
        return try await repository.getTerms()
    }
}
