//
//  ProfileSummaryRemoteDataSourceProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//


import Foundation

protocol ProfileSummaryRemoteDataSourceProtocol {
    func getProfileSummary() async throws -> ProfileSummaryResponseDTO
    func updateFamilyMembers(_ requestDTO: FamilyMembersUpdateRequestDTO) async throws -> ProfileSummaryResponseDTO
}
