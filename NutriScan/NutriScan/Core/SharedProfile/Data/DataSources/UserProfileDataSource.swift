//
//  SharedProfileDataSource.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

protocol UserProfileDataSourceProtocol {
    func getProfile() async throws -> UserProfileResponseDTO
    func updateProfile(requestDTO: EditProfileUpdateRequestDTO) async throws
        -> UserProfileResponseDTO
    func updateFamilyMembers(_ requestDTO: FamilyMembersUpdateRequestDTO)
        async throws -> UserProfileResponseDTO
    func getAllergies() async throws -> [ReferenceItemDTO]
    func getDiseases() async throws -> [ReferenceItemDTO]

    // Streak Methods
    func getStreak() async throws -> Int
    func updateStreak() async throws

    func uploadProfileImage(data: Data) async throws
    func uploadFamilyMemberImage(id: String, data: Data) async throws
        -> FamilyMemberDTO
}

final class UserProfileDataSource: UserProfileDataSourceProtocol {

    private let networkService: NetworkServiceProtocol

    // MARK: - Streak Mock Properties
    private let defaults = UserDefaults.standard
    private let streakKey = "mock_backend_streak_count"
    private let lastVisitKey = "mock_backend_last_visit_date"

    init(
        networkService: NetworkServiceProtocol = DIContainer.shared.resolve(
            type: NetworkServiceProtocol.self)
    ) {
        self.networkService = networkService
    }

    func getProfile() async throws -> UserProfileResponseDTO {
        try await networkService.request(UserProfileEndpoint.getProfile)
    }

    func updateProfile(requestDTO: EditProfileUpdateRequestDTO) async throws
        -> UserProfileResponseDTO
    {
        try await networkService.request(
            UserProfileEndpoint.updateProfile(requestDTO))
    }

    func updateFamilyMembers(_ requestDTO: FamilyMembersUpdateRequestDTO)
        async throws -> UserProfileResponseDTO
    {
        try await networkService.request(
            UserProfileEndpoint.updateFamilyMembers(requestDTO))
    }

    func getAllergies() async throws -> [ReferenceItemDTO] {
        try await networkService.request(UserProfileEndpoint.getAllergies)
    }

    func getDiseases() async throws -> [ReferenceItemDTO] {
        try await networkService.request(UserProfileEndpoint.getDiseases)
    }

    // MARK: - Streak Methods (Real Backend Integration)

    func getStreak() async throws -> Int {
        let profileDTO: UserProfileResponseDTO =
            try await networkService.request(UserProfileEndpoint.getProfile)
        return profileDTO.dailyStreak ?? 0
    }

    func updateStreak() async throws {
        let endpoint = UserProfileEndpoint.updateStreak
        let _: EmptyResponse = try await networkService.request(endpoint)
    }

    func uploadProfileImage(data: Data) async throws {
        let endpoint = UserProfileEndpoint.uploadImage(data)
        let _: EmptyResponse = try await networkService.request(endpoint)
    }

    func uploadFamilyMemberImage(id: String, data: Data) async throws
        -> FamilyMemberDTO
    {
        let endpoint = UserProfileEndpoint.uploadFamilyMemberImage(
            id: id, data: data)
        return try await networkService.request(endpoint)
    }
}
