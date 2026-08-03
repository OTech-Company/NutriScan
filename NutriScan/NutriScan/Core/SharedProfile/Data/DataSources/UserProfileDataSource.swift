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

    // MARK: - Streak Logic (Mock)
    func getStreak() async throws -> Int {
        try await Task.sleep(nanoseconds: 300_000_000)
        return defaults.integer(forKey: streakKey)
    }

    func updateStreak() async throws {
        try await Task.sleep(nanoseconds: 300_000_000)

        let calendar = Calendar.current
        let now = Date()
        let currentStreak = defaults.integer(forKey: streakKey)

        if let lastVisit = defaults.object(forKey: lastVisitKey) as? Date {
            if calendar.isDateInToday(lastVisit) {
                return
            } else if calendar.isDateInYesterday(lastVisit) {
                defaults.set(currentStreak + 1, forKey: streakKey)
            } else {
                defaults.set(1, forKey: streakKey)
            }
        } else {
            defaults.set(1, forKey: streakKey)
        }

        defaults.set(now, forKey: lastVisitKey)
    }
    func uploadProfileImage(data: Data) async throws {
        let endpoint = UserProfileEndpoint.uploadImage(data)

        // This leverages your NetworkService's built-in token injection,
        // multipart encoding, and retry logic.
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
