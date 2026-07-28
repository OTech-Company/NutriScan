//
//  SharedProfileDataSource.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

protocol SharedProfileDataSourceProtocol {
    func getProfile() async throws -> SharedProfileResponseDTO
    func updateProfile(requestDTO: EditProfileUpdateRequestDTO) async throws -> SharedProfileResponseDTO
    func updateFamilyMembers(_ requestDTO: FamilyMembersUpdateRequestDTO) async throws -> SharedProfileResponseDTO
    func getAllergies() async throws -> [ReferenceItemDTO]
    func getDiseases() async throws -> [ReferenceItemDTO]
    
    // Streak Methods
    func getStreak() async throws -> Int
    func updateStreak() async throws
}

final class SharedProfileDataSource: SharedProfileDataSourceProtocol {
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Streak Mock Properties
    private let defaults = UserDefaults.standard
    private let streakKey = "mock_backend_streak_count"
    private let lastVisitKey = "mock_backend_last_visit_date"

    init(networkService: NetworkServiceProtocol = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)) {
        self.networkService = networkService
    }

    func getProfile() async throws -> SharedProfileResponseDTO {
        try await networkService.request(SharedProfileEndpoint.getProfile)
    }

    func updateProfile(requestDTO: EditProfileUpdateRequestDTO) async throws -> SharedProfileResponseDTO {
        try await networkService.request(SharedProfileEndpoint.updateProfile(requestDTO))
    }
    
    func updateFamilyMembers(_ requestDTO: FamilyMembersUpdateRequestDTO) async throws -> SharedProfileResponseDTO {
        try await networkService.request(SharedProfileEndpoint.updateFamilyMembers(requestDTO))
    }

    func getAllergies() async throws -> [ReferenceItemDTO] {
        try await networkService.request(SharedProfileEndpoint.getAllergies)
    }

    func getDiseases() async throws -> [ReferenceItemDTO] {
        try await networkService.request(SharedProfileEndpoint.getDiseases)
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
}
