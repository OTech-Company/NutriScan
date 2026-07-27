//
//  ProfileRepositoryProtocol.swift
//  NutriScan
//

import Foundation

protocol ProfileRepositoryProtocol {
    func getProfile() async throws -> ProfileInfo
    /// Sends the FULL family members list (partial update semantics per contract —
    /// send the complete desired state; add/edit/remove are all expressed as one array).
    func updateFamilyMembers(_ members: [FamilyMemberInput]) async throws -> ProfileInfo
    func getStreak() async throws -> Int
    func updateStreak() async throws
}
