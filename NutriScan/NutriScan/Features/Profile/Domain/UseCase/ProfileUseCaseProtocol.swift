//
//  ProfileUseCaseProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

protocol ProfileUseCaseProtocol {
    /// Concurrently fetches the user's profile and the master lists for allergies and diseases.
    func getEditProfileData() async throws -> (profile: Profile, allergies: [ReferenceItem], diseases: [ReferenceItem])
    
    /// Sends the updated profile data to the backend.
    func updateProfile(update: ProfileUpdate) async throws -> Profile
}
