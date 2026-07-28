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
    private var imageCacheVersion: String = ""

    init(
        dataSource: SharedProfileDataSourceProtocol = DIContainer.shared
            .resolve(type: SharedProfileDataSourceProtocol.self),
        sharedStore: SharedProfileStore = DIContainer.shared.resolve(
            type: SharedProfileStore.self)
    ) {
        self.dataSource = dataSource
        self.sharedStore = sharedStore
    }

    /// Helper to attach cache busting query parameters to the profile image URL
    private func processProfile(_ dto: SharedProfileResponseDTO) -> ProfileInfo
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
        let dto: SharedProfileResponseDTO = try await dataSource.getProfile()
        let profile = processProfile(dto)
        await MainActor.run { self.sharedStore.currentProfile = profile }
    }

    func updateProfile(update: ProfileUpdate) async throws {
        let requestDTO = update.toRequestDTO()
        let dto: SharedProfileResponseDTO = try await dataSource.updateProfile(
            requestDTO: requestDTO)
        let profile = processProfile(dto)
        await MainActor.run { self.sharedStore.currentProfile = profile }
    }

    func updateFamilyMembers(_ members: [FamilyMemberInput]) async throws {
        let requestDTO = FamilyMembersUpdateRequestDTO(
            familyMembers: members.map { $0.toRequestDTO() }
        )
        let dto: SharedProfileResponseDTO =
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
        // 1. Upload the raw image data[cite: 35]
        try await dataSource.uploadProfileImage(data: data)

        // 2. Generate a new cache version to force image reloading across screens[cite: 35]
        self.imageCacheVersion = UUID().uuidString

        // 3. Fetch the updated profile so the backend provides the new image URL[cite: 35]
        let updatedProfileDTO: SharedProfileResponseDTO =
            try await dataSource.getProfile()
        let profile = processProfile(updatedProfileDTO)

        // 4. Push the fresh profile with cache buster to the reactive store[cite: 35]
        await MainActor.run {
            self.sharedStore.currentProfile = profile
        }
    }
}
