//
//  ProfileRepositoryProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

protocol EditProfileRepositoryProtocol {
    func getProfile() async throws -> Profile
    
    func updateProfile(update: ProfileUpdate) async throws -> Profile
    
    func getAllergies() async throws -> [ReferenceItem]
    
    func getDiseases() async throws -> [ReferenceItem]
}
