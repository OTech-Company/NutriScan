//
//  SharedProfileRepository.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

final class UserProfileRepository: UserProfileRepositoryProtocol {
    private let dataSource: UserProfileDataSourceProtocol
    private let sharedStore: UserProfileStore
    private var imageCacheVersion: String = ""

    init(
        dataSource: UserProfileDataSourceProtocol = DIContainer.shared
            .resolve(type: UserProfileDataSourceProtocol.self),
        sharedStore: UserProfileStore = DIContainer.shared.resolve(
            type: UserProfileStore.self)
    ) {
        self.dataSource = dataSource
        self.sharedStore = sharedStore
    }

    /// Helper to attach cache busting query parameters to the profile image URL
    private func processProfile(_ dto: UserProfileResponseDTO) -> ProfileInfo
    {
        var domainProfile = dto.toDomain()
        if !imageCacheVersion.isEmpty, let originalURL = domainProfile.imageUrl,
            !originalURL.isEmpty
        {
            let separator = originalURL.contains("?") ? "&" : "?"
            domainProfile.imageUrl =
                "\(originalURL)\(separator)v=\(imageCacheVersion)"
        }
        return domainProfile
    }

    func getProfile() async throws {
        let dto: UserProfileResponseDTO = try await dataSource.getProfile()
        let profile = processProfile(dto)
        await MainActor.run { self.sharedStore.currentProfile = profile }
    }

    func updateProfile(update: ProfileUpdate) async throws {
        let requestDTO = update.toRequestDTO()
        let dto: UserProfileResponseDTO = try await dataSource.updateProfile(
            requestDTO: requestDTO)
        let profile = processProfile(dto)
        await MainActor.run { self.sharedStore.currentProfile = profile }
    }

    func updateFamilyMembers(_ members: [FamilyMemberInput]) async throws {
        let requestDTO = FamilyMembersUpdateRequestDTO(
            familyMembers: members.map { $0.toRequestDTO() }
        )
        let dto: UserProfileResponseDTO =
            try await dataSource.updateFamilyMembers(requestDTO)
        let profile = processProfile(dto)
        await MainActor.run { self.sharedStore.currentProfile = profile }
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
        try await dataSource.uploadProfileImage(data: data)

        self.imageCacheVersion = UUID().uuidString

        let updatedProfileDTO: UserProfileResponseDTO =
            try await dataSource.getProfile()
        let profile = processProfile(updatedProfileDTO)

        await MainActor.run {
            self.sharedStore.currentProfile = profile
        }
    }
}
