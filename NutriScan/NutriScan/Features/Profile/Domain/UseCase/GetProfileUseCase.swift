//
//  empty.swift
//  NutriScan
//
//  Created by Osama Hosam on 13/07/2026.
//

struct GetProfileUseCase {
    private let repository: ProfileRepositoryOsama
    
    init(repository: ProfileRepositoryOsama) {
        self.repository = repository
    }
    
    func execute() async throws -> UserProfile {
        return try await repository.getUserProfile()
    }
}
