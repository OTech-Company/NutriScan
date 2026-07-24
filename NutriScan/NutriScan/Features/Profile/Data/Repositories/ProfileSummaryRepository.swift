//
//  ProfileSummaryRepository.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

final class ProfileSummaryRepository: ProfileSummaryRepositoryProtocol {
    private let remoteDataSource: ProfileSummaryRemoteDataSourceProtocol

    init(remoteDataSource: ProfileSummaryRemoteDataSourceProtocol = DIContainer.shared.resolve(type: ProfileSummaryRemoteDataSourceProtocol.self)) {
        self.remoteDataSource = remoteDataSource
    }

    func getProfileSummary() async throws -> ProfileSummary {
        let dto = try await remoteDataSource.getProfileSummary()
        return ProfileMapper.map(dto: dto)
    }

    func updateFamilyMembers(_ members: [FamilyMemberInput]) async throws -> ProfileSummary {
        let requestDTO = ProfileMapper.map(inputs: members)
        let dto = try await remoteDataSource.updateFamilyMembers(requestDTO)
        return ProfileMapper.map(dto: dto)
    }
}
