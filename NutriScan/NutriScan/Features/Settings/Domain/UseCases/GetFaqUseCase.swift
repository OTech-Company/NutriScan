//
//  GetFaqUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import Foundation

protocol GetFaqUseCaseProtocol {
    func execute() async throws -> [FaqItem]
}

struct GetFaqUseCase: GetFaqUseCaseProtocol {
    private let repository: HelpRepositoryProtocol

    init(
        repository: HelpRepositoryProtocol = DIContainer.shared.resolve(
            type: HelpRepositoryProtocol.self)
    ) {
        self.repository = repository
    }

    func execute() async throws -> [FaqItem] {
        return try await repository.getFaqs()
    }
}
