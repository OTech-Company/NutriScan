//
//  ProfileRemoteDataSource.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 23/07/2026.
//

final class ProfileRemoteDataSource: ProfileRemoteDataSourceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)) {
        self.networkService = networkService
    }

    func getProfile() async throws -> EditProfileResponseDTO {
        return try await networkService.request(EditProfileEndpoint.getProfile)
    }

    func updateProfile(requestDTO: EditProfileUpdateRequestDTO) async throws -> EditProfileResponseDTO {
        return try await networkService.request(EditProfileEndpoint.updateProfile(requestDTO))
    }

    func getAllergies() async throws -> [ReferenceItemDTO] {
        return try await networkService.request(EditProfileEndpoint.getAllergies)
    }

    func getDiseases() async throws -> [ReferenceItemDTO] {
        return try await networkService.request(EditProfileEndpoint.getDiseases)
    }
}
