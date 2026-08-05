//
//  SharedProfileRepositoryProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

protocol UserProfileRepositoryProtocol {
    func getProfile() async throws
    func updateProfile(update: ProfileUpdate) async throws
    func updateFamilyMembers(_ members: [FamilyMemberInput]) async throws
    func getAllergies() async throws -> [ReferenceItem]
    func getDiseases() async throws -> [ReferenceItem]
    func getStreak() async throws -> Int
    func updateStreak() async throws
    func uploadProfileImage(data: Data) async throws
    func uploadFamilyMemberImage(id: String, data: Data) async throws
}
