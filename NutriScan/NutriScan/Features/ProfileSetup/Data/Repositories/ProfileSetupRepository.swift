//
//  ProfileSetupRepository.swift
//  NutriScan
//

import Foundation

final class ProfileSetupRepository: ProfileSetupRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func updateProfile(_ update: ProfileSetupUpdate) async throws -> ProfileSetupUserProfile {
        let dto = ProfileSetupUpdateDTO(domain: update)
        // Since updateProfile could potentially return empty/204, we decode to ProfileSetupResponseDTO.
        // The prompt says "if it can be empty, add handling similar to EmptyResponse". 
        // We will try decoding to the normal response first. If it's a 204 or empty, NetworkService handles EmptyResponse but only if we ask for it.
        // Wait, NetworkService's generic request function handles EmptyResponse automatically if T is EmptyResponse.
        // But here T is ProfileSetupResponseDTO. If the body is truly empty but statusCode is 200...299, and not 204, it might fail.
        // If it's 204, NetworkService tries to cast EmptyResponse to T. That would fail here since T is ProfileSetupResponseDTO.
        // Let's assume it returns the profile as the contract doc specifies 200 OK with the updated profile in the same shape.
        let response: ProfileSetupResponseDTO = try await networkService.request(ProfileSetupEndpoint.updateProfile(dto))
        return response.toDomain()
    }

    func fetchAllergyOptions() async throws -> [ProfileSetupAllergyOption] {
        let dtos: [ProfileSetupAllergyDTO] = try await networkService.request(ProfileSetupEndpoint.fetchAllergyOptions)
        return dtos.map { ProfileSetupAllergyOption(id: $0.id, name: $0.name) }
    }

    func fetchDiseaseOptions() async throws -> [ProfileSetupDiseaseOption] {
        let dtos: [ProfileSetupDiseaseDTO] = try await networkService.request(ProfileSetupEndpoint.fetchDiseaseOptions)
        return dtos.map { ProfileSetupDiseaseOption(id: $0.id, name: $0.name) }
    }
}
