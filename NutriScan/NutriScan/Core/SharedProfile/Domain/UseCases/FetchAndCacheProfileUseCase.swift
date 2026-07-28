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
    private let repository: SharedProfileRepositoryProtocol
    
    init(repository: SharedProfileRepositoryProtocol = DIContainer.shared.resolve(type: SharedProfileRepositoryProtocol.self)) {
        self.repository = repository
    }
    
    func execute() async throws {
        // This fires the network call, which inherently updates the SharedStore
        try await repository.getProfile()
    }
}
