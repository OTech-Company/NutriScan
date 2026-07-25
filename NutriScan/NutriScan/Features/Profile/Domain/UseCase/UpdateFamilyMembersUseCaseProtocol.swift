//
//  UpdateFamilyMembersUseCaseProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

protocol UpdateFamilyMembersUseCaseProtocol {
    func execute(members: [FamilyMemberInput]) async throws -> ProfileSummary
}
