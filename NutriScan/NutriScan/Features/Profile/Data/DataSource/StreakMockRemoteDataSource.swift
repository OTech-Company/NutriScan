//
//  StreakMockRemoteDataSource.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//

import Foundation

final class StreakMockRemoteDataSource: StreakRemoteDataSourceProtocol {
    private let defaults = UserDefaults.standard
    private let streakKey = "mock_backend_streak_count"
    private let lastVisitKey = "mock_backend_last_visit_date"
    
    func getStreak() async throws -> Int {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000)
        return defaults.integer(forKey: streakKey)
    }
    
    func updateStreak() async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000)
        
        let calendar = Calendar.current
        let now = Date()
        let currentStreak = defaults.integer(forKey: streakKey)
        
        if let lastVisit = defaults.object(forKey: lastVisitKey) as? Date {
            if calendar.isDateInToday(lastVisit) {
                // Already visited today; backend does nothing
                return
            } else if calendar.isDateInYesterday(lastVisit) {
                // Visited yesterday; backend increments streak
                defaults.set(currentStreak + 1, forKey: streakKey)
            } else {
                // Missed a day or more; backend resets streak
                defaults.set(1, forKey: streakKey)
            }
        } else {
            // First time ever visiting
            defaults.set(1, forKey: streakKey)
        }
        
        // Record the visit date
        defaults.set(now, forKey: lastVisitKey)
    }
}
