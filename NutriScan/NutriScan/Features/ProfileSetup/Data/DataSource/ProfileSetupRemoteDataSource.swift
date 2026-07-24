//
//  ProfileSetupRemoteDataSource.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 24/07/2026.
//

import Foundation
protocol ProfileSetupRemoteDataSourceProtocol {
    func updateProfile(_ update: ProfileSetupUpdateDTO) async throws -> ProfileSetupResponseDTO
    func fetchAllergyOptions() async throws -> [ProfileSetupAllergyDTO]
    func fetchDiseaseOptions() async throws -> [ProfileSetupDiseaseDTO]
}
final class ProfileSetupRemoteDataSource: ProfileSetupRemoteDataSourceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func updateProfile(_ update: ProfileSetupUpdateDTO) async throws -> ProfileSetupResponseDTO {
        return try await networkService.request(ProfileSetupEndpoint.updateProfile(update))
    }
    
    func fetchAllergyOptions() async throws -> [ProfileSetupAllergyDTO] {
        return try await networkService.request(ProfileSetupEndpoint.fetchAllergyOptions)
    }
    
    func fetchDiseaseOptions() async throws -> [ProfileSetupDiseaseDTO] {
        return try await networkService.request(ProfileSetupEndpoint.fetchDiseaseOptions)
    }
}
