//
//  ProfileDataSource.swift
//  NutriScan
//

import Foundation


protocol ProfileDataSourceProtocol {
    func getProfileSummary() async throws -> ProfileSummaryResponseDTO
    func updateFamilyMembers(_ dto: FamilyMembersUpdateRequestDTO) async throws -> ProfileSummaryResponseDTO
    func getStreak() async throws -> Int
    func updateStreak() async throws
}


final class ProfileDataSource: ProfileDataSourceProtocol {

    private let networkService: NetworkServiceProtocol


    private let defaults = UserDefaults.standard
    private let streakKey = "mock_backend_streak_count"
    private let lastVisitKey = "mock_backend_last_visit_date"

    init(networkService: NetworkServiceProtocol = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)) {
        self.networkService = networkService
    }


    func getProfileSummary() async throws -> ProfileSummaryResponseDTO {
        try await networkService.request(ProfileSummaryEndpoint.getProfileSummary)
    }

    func updateFamilyMembers(_ dto: FamilyMembersUpdateRequestDTO) async throws -> ProfileSummaryResponseDTO {
        try await networkService.request(ProfileSummaryEndpoint.updateFamilyMembers(dto))
    }


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
