//
//  ProfileRemoteDataSourceProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 23/07/2026.
//

import Foundation

protocol ProfileRemoteDataSourceProtocol {
    func getProfile() async throws -> ProfileResponseDTO
    func updateProfile(requestDTO: ProfileUpdateRequestDTO) async throws -> ProfileResponseDTO
    func getAllergies() async throws -> [ReferenceItemDTO]
    func getDiseases() async throws -> [ReferenceItemDTO]
}
