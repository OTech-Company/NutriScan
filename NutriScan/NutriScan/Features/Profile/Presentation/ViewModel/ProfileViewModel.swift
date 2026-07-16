//
//  ProfileViewModel.swift
//  NutriScan
//
//  Created by Osama Hosam on 16/07/2026.
//

import Foundation
import Observation

enum ProfileUiState {
    case loading
    case success(UserProfile, streakCount: Int, badgesCount: Int)
    case error(String)
}

@Observable
final class ProfileViewModel {
    var uiState: ProfileUiState = .loading
    private let getProfileUseCase: GetProfileUseCase
    
    init(getProfileUseCase: GetProfileUseCase) {
        self.getProfileUseCase = getProfileUseCase
    }
    
    func loadProfile() async {
        uiState = .loading
        do {
            let profile = try await getProfileUseCase.execute()
            // In a real app, streak and badges would come from a gamification domain/use case
            uiState = .success(profile, streakCount: 15, badgesCount: 5)
        } catch {
            uiState = .error(error.localizedDescription)
        }
    }
    
    func toggleNotifications(isEnabled: Bool) {
        // Notification toggle integration logic
    }
}
