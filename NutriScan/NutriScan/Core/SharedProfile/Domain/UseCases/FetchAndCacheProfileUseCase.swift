//
//  FetchAndCacheProfileUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

protocol FetchAndCacheProfileUseCaseProtocol {
    func execute() async throws
}

struct FetchAndCacheProfileUseCase: FetchAndCacheProfileUseCaseProtocol {
    private let repository: UserProfileRepositoryProtocol
    
    init(repository: UserProfileRepositoryProtocol = DIContainer.shared.resolve(type: UserProfileRepositoryProtocol.self)) {
        self.repository = repository
    }
    
    func execute() async throws {
        // This fires the network call, which inherently updates the SharedStore
        try await repository.getProfile()
    }
}
