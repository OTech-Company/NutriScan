//
//  UpdateProfileUseCaseProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

protocol UpdateEditProfileUseCaseProtocol {
    /// Sends the updated profile data to the backend.
    func execute(update: ProfileUpdate) async throws -> Profile
}
