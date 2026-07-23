//
//  ProfileRepository.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

final class ProfileRepository: ProfileRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)) {
            self.networkService = networkService
        }

    func getProfile() async throws -> Profile {
        let dto: ProfileResponseDTO = try await networkService.request(ProfileEndpoint.getProfile)
        return ProfileMapper.map(dto: dto)
    }

    func updateProfile(update: ProfileUpdate) async throws -> Profile {
        let requestDTO = ProfileMapper.map(update: update)
        let responseDTO: ProfileResponseDTO = try await networkService.request(ProfileEndpoint.updateProfile(requestDTO))
        return ProfileMapper.map(dto: responseDTO)
    }

    func getAllergies() async throws -> [ReferenceItem] {
        let dtos: [ReferenceItemDTO] = try await networkService.request(ProfileEndpoint.getAllergies)
        return dtos.map { ProfileMapper.map(dto: $0) }
    }

    func getDiseases() async throws -> [ReferenceItem] {
        let dtos: [ReferenceItemDTO] = try await networkService.request(ProfileEndpoint.getDiseases)
        return dtos.map { ProfileMapper.map(dto: $0) }
    }
}
