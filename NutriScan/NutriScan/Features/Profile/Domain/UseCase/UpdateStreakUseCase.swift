//
//  UpdateStreakUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//
import Foundation

final class UpdateStreakUseCase: UpdateStreakUseCaseProtocol {
    private let repository: StreakRepositoryProtocol
    
    init(repository: StreakRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.updateStreak()
    }
}
