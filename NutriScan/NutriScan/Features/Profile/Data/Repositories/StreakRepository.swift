//
//  StreakRepository.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//

import Foundation

final class StreakRepository: StreakRepositoryProtocol {
    private let remoteDataSource: StreakRemoteDataSourceProtocol
    
    init(remoteDataSource: StreakRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getStreak() async throws -> Int {
        return try await remoteDataSource.getStreak()
    }
    
    func updateStreak() async throws {
        try await remoteDataSource.updateStreak()
    }
}
