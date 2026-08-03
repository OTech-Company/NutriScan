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
        dataSource: UserProfileDataSourceProtocol = DIContainer.shared.resolve(type: UserProfileDataSourceProtocol.self),
        sharedStore: UserProfileStore = DIContainer.shared.resolve(type: UserProfileStore.self)
    ) {
        self.dataSource = dataSource
        self.sharedStore = sharedStore
    }
    
    // MARK: - URL Helpers
    
    /// Safely appends or updates a cache-busting query parameter using URLComponents
    private func applyCacheBuster(to urlString: String?, version: String) -> String? {
        guard let urlString = urlString,
              !urlString.isEmpty,
              var components = URLComponents(string: urlString) else {
            return urlString
        }
        
        var queryItems = components.queryItems ?? []
        // Remove any existing "v" parameter to prevent duplicates if the URL already had one
        queryItems.removeAll(where: { $0.name == "v" })
        queryItems.append(URLQueryItem(name: "v", value: version))
        
        components.queryItems = queryItems
        return components.string
    }

    private func processProfile(_ dto: UserProfileResponseDTO) -> ProfileInfo {
        var domainProfile = dto.toDomain()
        if !imageCacheVersion.isEmpty {
            domainProfile.imageUrl = applyCacheBuster(to: domainProfile.imageUrl, version: imageCacheVersion)
        }
        return domainProfile
    }

    // MARK: - Protocol Methods

    func getProfile() async throws {
        let dto: UserProfileResponseDTO = try await dataSource.getProfile()
        let profile = processProfile(dto)
        await MainActor.run { self.sharedStore.currentProfile = profile }
    }

    func updateProfile(update: ProfileUpdate) async throws {
        let requestDTO = update.toRequestDTO()
        let dto: UserProfileResponseDTO = try await dataSource.updateProfile(requestDTO: requestDTO)
        let profile = processProfile(dto)
        await MainActor.run { self.sharedStore.currentProfile = profile }
    }

    func updateFamilyMembers(_ members: [FamilyMemberInput]) async throws {
        let requestDTO = FamilyMembersUpdateRequestDTO(
            familyMembers: members.map { $0.toRequestDTO() }
        )
        let dto: UserProfileResponseDTO = try await dataSource.updateFamilyMembers(requestDTO)
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

    // MARK: - Image Uploads
    
    func uploadProfileImage(data: Data) async throws {
        try await dataSource.uploadProfileImage(data: data)
        self.imageCacheVersion = UUID().uuidString

        let updatedProfileDTO: UserProfileResponseDTO = try await dataSource.getProfile()
        let profile = processProfile(updatedProfileDTO)

        await MainActor.run {
            self.sharedStore.currentProfile = profile
        }
    }
    
    func uploadFamilyMemberImage(id: String, data: Data) async throws {
        let updatedMemberDTO = try await dataSource.uploadFamilyMemberImage(id: id, data: data)
        var updatedMember = updatedMemberDTO.toDomain()
        
        updatedMember.imageUrl = applyCacheBuster(to: updatedMember.imageUrl, version: UUID().uuidString)
        
        await MainActor.run {
            if var currentProfile = self.sharedStore.currentProfile {
                if let index = currentProfile.familyMembers.firstIndex(where: { $0.id == id }) {
                    currentProfile.familyMembers[index] = updatedMember
                    self.sharedStore.currentProfile = currentProfile
                }
            }
        }
    }
}
