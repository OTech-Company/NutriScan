//
//  GetReferenceDataUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

protocol GetReferenceDataUseCaseProtocol {
    func execute() async throws -> (allergies: [ReferenceItem], diseases: [ReferenceItem])
}

struct GetReferenceDataUseCase: GetReferenceDataUseCaseProtocol {
    private let repository: SharedProfileRepositoryProtocol
    
    init(repository: SharedProfileRepositoryProtocol = DIContainer.shared.resolve(type: SharedProfileRepositoryProtocol.self)) {
        self.repository = repository
    }
    
    func execute() async throws -> (allergies: [ReferenceItem], diseases: [ReferenceItem]) {
        // Run both network requests concurrently for maximum efficiency
        async let allergies = repository.getAllergies()
        async let diseases = repository.getDiseases()
        
        return try await (allergies, diseases)
    }
}
