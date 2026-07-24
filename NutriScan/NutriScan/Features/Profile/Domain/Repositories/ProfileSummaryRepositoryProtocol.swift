//
//  ProfileSummaryRepositoryProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

protocol ProfileSummaryRepositoryProtocol {
    func getProfileSummary() async throws -> ProfileSummary
    /// Sends the FULL family members list (partial update semantics per contract —
    /// send the complete desired state; add/edit/remove are all expressed as one array).
    func updateFamilyMembers(_ members: [FamilyMemberInput]) async throws -> ProfileSummary
}
