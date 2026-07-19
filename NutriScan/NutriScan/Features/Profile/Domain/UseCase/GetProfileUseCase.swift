//
//  empty.swift
//  NutriScan
//
//  Created by Osama Hosam on 13/07/2026.
//

struct GetProfileUseCase {
    private let repository: ProfileRepository
    
    init(repository: ProfileRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> UserProfile {
        return try await repository.getUserProfile()
    }
}
