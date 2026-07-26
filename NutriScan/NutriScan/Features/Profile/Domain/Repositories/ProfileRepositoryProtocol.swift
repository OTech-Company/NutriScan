//
//  ProfileRepositoryProtocol.swift
//  NutriScan
//

import Foundation

protocol ProfileRepositoryProtocol {

    func getProfileSummary() async throws -> ProfileSummary
    func updateFamilyMembers(_ members: [FamilyMemberInput]) async throws -> ProfileSummary
    func getStreak() async throws -> Int
    func updateStreak() async throws
    
}
