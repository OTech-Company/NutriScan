//
//  FetchProfileSetupOptionsUseCase.swift
//  NutriScan
//

import Foundation

protocol FetchProfileSetupOptionsUseCaseProtocol {
    func execute() async throws -> (allergies: [ProfileSetupAllergyOption], diseases: [ProfileSetupDiseaseOption])
}

final class FetchProfileSetupOptionsUseCase: FetchProfileSetupOptionsUseCaseProtocol {
    private let repository: ProfileSetupRepositoryProtocol
    
    init(repository: ProfileSetupRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> (allergies: [ProfileSetupAllergyOption], diseases: [ProfileSetupDiseaseOption]) {
        async let allergies = repository.fetchAllergyOptions()
        async let diseases = repository.fetchDiseaseOptions()
        return try await (allergies, diseases)
    }
}
