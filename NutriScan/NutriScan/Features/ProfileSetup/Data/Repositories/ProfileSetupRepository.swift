//
//  ProfileSetupRepository.swift
//  NutriScan
//

import Foundation

final class ProfileSetupRepository: ProfileSetupRepositoryProtocol {
    private let remoteDataSource: ProfileSetupRemoteDataSourceProtocol
    
    init(remoteDataSource: ProfileSetupRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func updateProfile(_ update: ProfileSetupUpdate) async throws -> ProfileSetupUserProfile {
        let dto = ProfileSetupUpdateDTO(domain: update)
        let response = try await remoteDataSource.updateProfile(dto)
        return response.toDomain()
    }

    func fetchAllergyOptions() async throws -> [ProfileSetupAllergyOption] {
        let dtos = try await remoteDataSource.fetchAllergyOptions()
        return dtos.map { ProfileSetupAllergyOption(id: $0.id, name: $0.name) }
    }

    func fetchDiseaseOptions() async throws -> [ProfileSetupDiseaseOption] {
        let dtos = try await remoteDataSource.fetchDiseaseOptions()
        return dtos.map { ProfileSetupDiseaseOption(id: $0.id, name: $0.name) }
    }
}
