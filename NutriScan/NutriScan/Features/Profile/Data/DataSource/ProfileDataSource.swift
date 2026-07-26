//
//  ProfileDataSource.swift
//  NutriScan
//

import Foundation

// MARK: - Protocol

protocol ProfileDataSourceProtocol {
    func getProfile() async throws -> ProfileResponseDTO
    func updateFamilyMembers(_ dto: FamilyMembersUpdateRequestDTO) async throws -> ProfileResponseDTO
    func getStreak() async throws -> Int
    func updateStreak() async throws
}

// MARK: - Implementation

final class ProfileDataSource: ProfileDataSourceProtocol {

    // MARK: - Profile (Remote)

    private let networkService: NetworkServiceProtocol

    // MARK: - Streak (Mock – replace with real network call when endpoint is ready)

    private let defaults = UserDefaults.standard
    private let streakKey = "mock_backend_streak_count"
    private let lastVisitKey = "mock_backend_last_visit_date"

    init(networkService: NetworkServiceProtocol = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)) {
        self.networkService = networkService
    }

    // MARK: - ProfileDataSourceProtocol

    func getProfile() async throws -> ProfileResponseDTO {
        try await networkService.request(ProfileEndpoint.getProfile)
    }

    func updateFamilyMembers(_ dto: FamilyMembersUpdateRequestDTO) async throws -> ProfileResponseDTO {
        try await networkService.request(ProfileEndpoint.updateFamilyMembers(dto))
    }

    // MARK: - Streak (Mock)

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
}
