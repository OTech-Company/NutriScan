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
    private let repository: SharedProfileRepositoryProtocol
    init(repository: SharedProfileRepositoryProtocol = DIContainer.shared.resolve(type: SharedProfileRepositoryProtocol.self)) { self.repository = repository }
    
    func execute() async throws -> Int {
        try await repository.getStreak()
    }
}

