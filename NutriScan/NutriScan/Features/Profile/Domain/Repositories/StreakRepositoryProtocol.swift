//
//  StreakRepositoryProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//
import Foundation

protocol StreakRepositoryProtocol {
    func getStreak() async throws -> Int
    func updateStreak() async throws
}
