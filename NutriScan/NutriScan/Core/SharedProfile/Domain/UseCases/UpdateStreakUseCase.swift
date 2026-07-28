//
//  UpdateStreakUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

protocol UpdateStreakUseCaseProtocol {
    func execute() async throws
}

struct UpdateStreakUseCase: UpdateStreakUseCaseProtocol {
    private let repository: SharedProfileRepositoryProtocol
    init(repository: SharedProfileRepositoryProtocol = DIContainer.shared.resolve(type: SharedProfileRepositoryProtocol.self)) { self.repository = repository }
    
    func execute() async throws {
        try await repository.updateStreak()
    }
}
