//
//  ProfileSetupRepositoryProtocol.swift
//  NutriScan
//

import Foundation

protocol ProfileSetupRepositoryProtocol {
    func updateProfile(_ update: ProfileSetupUpdate) async throws -> ProfileSetupUserProfile
    func fetchAllergyOptions() async throws -> [ProfileSetupAllergyOption]
    func fetchDiseaseOptions() async throws -> [ProfileSetupDiseaseOption]
}
