//
//  GetStreakUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//
import Foundation

final class GetStreakUseCase: GetStreakUseCaseProtocol {
    private let repository: StreakRepositoryProtocol
    
    init(repository: StreakRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> Int {
        return try await repository.getStreak()
    }
}
