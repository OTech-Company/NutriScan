//
//  ProfileRepository.swift
//  NutriScan
//

import Foundation

final class ProfileRepository: ProfileRepositoryProtocol {
    private let dataSource: ProfileDataSourceProtocol

    init(dataSource: ProfileDataSourceProtocol = DIContainer.shared.resolve(type: ProfileDataSourceProtocol.self)) {
        self.dataSource = dataSource
    }

    func getProfile() async throws -> ProfileInfo {
        let dto = try await dataSource.getProfile()
        return dto.toDomain()
    }

    func updateFamilyMembers(_ members: [FamilyMemberInput]) async throws -> ProfileInfo {
        let requestDTO = FamilyMembersUpdateRequestDTO(
            familyMembers: members.map { $0.toRequestDTO() }
        )
        let dto = try await dataSource.updateFamilyMembers(requestDTO)
        return dto.toDomain()
    }

    func getStreak() async throws -> Int {
        try await dataSource.getStreak()
    }

    func updateStreak() async throws {
        try await dataSource.updateStreak()
    }
}
