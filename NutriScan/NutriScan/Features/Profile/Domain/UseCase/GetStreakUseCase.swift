//
//  StreakUseCases.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

protocol GetStreakUseCaseProtocol {
    func execute() async throws -> Int
}

struct GetStreakUseCase: GetStreakUseCaseProtocol {
    private let repository: UserProfileRepositoryProtocol
    init(repository: UserProfileRepositoryProtocol = DIContainer.shared.resolve(type: UserProfileRepositoryProtocol.self)) { self.repository = repository }
    
    func execute() async throws -> Int {
        try await repository.getStreak()
    }
}

