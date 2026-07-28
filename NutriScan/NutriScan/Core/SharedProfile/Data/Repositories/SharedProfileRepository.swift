//
//  SharedProfileRepository.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

final class SharedProfileRepository: SharedProfileRepositoryProtocol {
    private let dataSource: SharedProfileDataSourceProtocol
    private let sharedStore: SharedProfileStore

    init(
        dataSource: SharedProfileDataSourceProtocol = DIContainer.shared
            .resolve(type: SharedProfileDataSourceProtocol.self),
        sharedStore: SharedProfileStore = DIContainer.shared.resolve(
            type: SharedProfileStore.self)
    ) {
        self.dataSource = dataSource
        self.sharedStore = sharedStore
    }

    func getProfile() async throws {
        let dto: SharedProfileResponseDTO = try await dataSource.getProfile()
        await MainActor.run { self.sharedStore.currentProfile = dto.toDomain() }
    }

    func updateProfile(update: ProfileUpdate) async throws {
        let requestDTO = update.toRequestDTO()
        let dto: SharedProfileResponseDTO = try await dataSource.updateProfile(
            requestDTO: requestDTO)
        await MainActor.run { self.sharedStore.currentProfile = dto.toDomain() }
    }

    func updateFamilyMembers(_ members: [FamilyMemberInput]) async throws {
        let requestDTO = FamilyMembersUpdateRequestDTO(
            familyMembers: members.map { $0.toRequestDTO() }  // Assuming you kept your FamilyMemberInput+DTO mapper
        )
        let dto: SharedProfileResponseDTO =
            try await dataSource.updateFamilyMembers(requestDTO)
        await MainActor.run { self.sharedStore.currentProfile = dto.toDomain() }
    }

    func getAllergies() async throws -> [ReferenceItem] {
        let dtos = try await dataSource.getAllergies()
        return dtos.map { ReferenceItem(id: $0.id, name: $0.name) }
    }

    func getDiseases() async throws -> [ReferenceItem] {
        let dtos = try await dataSource.getDiseases()
        return dtos.map { ReferenceItem(id: $0.id, name: $0.name) }
    }

    // MARK: - Streak Methods
    func getStreak() async throws -> Int {
        let streak = try await dataSource.getStreak()
        await MainActor.run { self.sharedStore.streakDays = streak }
        return streak
    }

    func updateStreak() async throws {
        try await dataSource.updateStreak()
    }
    func uploadProfileImage(data: Data) async throws {
        // 1. Upload the raw image data
        try await dataSource.uploadProfileImage(data: data)

        // 2. Fetch the updated profile so the backend provides the new image URL
        let updatedProfileDTO: SharedProfileResponseDTO =
            try await dataSource.getProfile()

        // 3. Push the fresh profile to the reactive store to instantly update the UI globally
        await MainActor.run {
            self.sharedStore.currentProfile = updatedProfileDTO.toDomain()
        }
    }
}
