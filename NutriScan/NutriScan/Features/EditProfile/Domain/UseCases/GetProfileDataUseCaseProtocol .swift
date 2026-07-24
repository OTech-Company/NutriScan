//
//  GetProfileDataUseCaseProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

protocol GetEditProfileUseCaseProtocol {
    /// Concurrently fetches the user's profile and the master lists for allergies and diseases.
    func execute() async throws -> (profile: Profile, allergies: [ReferenceItem], diseases: [ReferenceItem])
}
