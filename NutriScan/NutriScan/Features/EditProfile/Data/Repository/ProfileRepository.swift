//
//  ProfileRepository.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

final class ProfileRepository: ProfileRepositoryProtocol {
    private let remoteDataSource: ProfileRemoteDataSourceProtocol

    init(remoteDataSource: ProfileRemoteDataSourceProtocol = DIContainer.shared.resolve(type: ProfileRemoteDataSourceProtocol.self)) {
        self.remoteDataSource = remoteDataSource
    }

    func getProfile() async throws -> Profile {
        let dto = try await remoteDataSource.getProfile()
        return ProfileMapper.map(dto: dto)
    }

    func updateProfile(update: ProfileUpdate) async throws -> Profile {
        let requestDTO = ProfileMapper.map(update: update)
        let responseDTO = try await remoteDataSource.updateProfile(requestDTO: requestDTO)
        return ProfileMapper.map(dto: responseDTO)
    }

    func getAllergies() async throws -> [ReferenceItem] {
        let dtos = try await remoteDataSource.getAllergies()
        return dtos.map { ProfileMapper.map(dto: $0) }
    }

    func getDiseases() async throws -> [ReferenceItem] {
        let dtos = try await remoteDataSource.getDiseases()
        return dtos.map { ProfileMapper.map(dto: $0) }
    }
}
