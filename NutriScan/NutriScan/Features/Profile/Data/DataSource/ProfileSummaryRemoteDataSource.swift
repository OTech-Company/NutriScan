//
//  ProfileSummaryRemoteDataSource.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

final class ProfileSummaryRemoteDataSource: ProfileSummaryRemoteDataSourceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)) {
        self.networkService = networkService
    }

    func getProfileSummary() async throws -> ProfileSummaryResponseDTO {
        try await networkService.request(ProfileSummaryEndpoint.getProfileSummary)
    }

    func updateFamilyMembers(_ requestDTO: FamilyMembersUpdateRequestDTO) async throws -> ProfileSummaryResponseDTO {
        try await networkService.request(ProfileSummaryEndpoint.updateFamilyMembers(requestDTO))
    }
}
