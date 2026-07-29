//
//  AppFlowCoordinator.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//
import SwiftUI

/// Decides which top-level `AppFlow` is currently shown, and exposes
/// the transitions between them. Injected once at the root and read
/// via `@EnvironmentObject` by any screen that can trigger a flow
/// change (e.g. `OnboardingView` finishing, `LoginView` succeeding,
/// a logout button inside Profile).
final class AppFlowCoordinator: ObservableObject {
    @Published private(set) var flow: AppFlow = .splash
    @Published var selectedTab: AppTab = .home
    
    // Inject the use case (you'll bind this in your DI setup)
    private let fetchAndCacheProfileUseCase: FetchAndCacheProfileUseCaseProtocol

    init(
        fetchAndCacheProfileUseCase: FetchAndCacheProfileUseCaseProtocol =
            DIContainer.shared.resolve(
                type: FetchAndCacheProfileUseCaseProtocol.self)
    ) {
        self.fetchAndCacheProfileUseCase = fetchAndCacheProfileUseCase

        NotificationCenter.default.addObserver(
            forName: .userDidSessionExpire,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.logout()
        }
    }

    private var hasCompletedOnboarding: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    }

    private var isAuthenticated: Bool {
        do {
            _ = try KeychainManager.shared.get(key: .accessToken)
            return true
        } catch {
            return false
        }
    }

    private var hasCompletedProfileSetup: Bool {
        UserDefaults.standard.bool(forKey: "hasCompletedProfileSetup")
    }

    @MainActor
    func finishSplash() {
        Task {
            if !hasCompletedOnboarding {
                flow = .onboarding
            } else if !isAuthenticated {
                flow = .auth
            } else if !hasCompletedProfileSetup {
                flow = .profileSetup
            } else {
                // EAGER LOAD: Fetch the profile data silently.
                _ = try? await fetchAndCacheProfileUseCase.execute()
                flow = .main
            }
        }
    }

    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        flow = .auth
    }

    @MainActor
    func didAuthenticate(isPendingSetup: Bool = false, email: String? = nil) {
        if isPendingSetup {
            UserDefaults.standard.set(false, forKey: "hasCompletedProfileSetup")
            if let email = email {
                UserDefaults.standard.set(email, forKey: "currentSetupEmail")
            }
            flow = .profileSetup
        } else {
            UserDefaults.standard.set(true, forKey: "hasCompletedProfileSetup")
            
            Task {
                // EAGER LOAD for fresh logins:
                // Fetch the profile data for the new session BEFORE transitioning
                // to the main flow to prevent "Failed to load" errors.
                _ = try? await fetchAndCacheProfileUseCase.execute()
                
                await MainActor.run {
                    self.flow = .main
                }
            }
        }
    }

    func finishProfileSetup() {
        if let email = UserDefaults.standard.string(forKey: "currentSetupEmail")
        {
            UserDefaults.standard.removeObject(
                forKey: "isPendingProfileSetup_\(email)")
            UserDefaults.standard.removeObject(forKey: "currentSetupEmail")
        }
        UserDefaults.standard.set(true, forKey: "hasCompletedProfileSetup")
        flow = .main
    }

    func logout() {
        try? KeychainManager.shared.delete(key: .accessToken)
        try? KeychainManager.shared.delete(key: .refreshToken)

        // Clear the shared cache so the next user doesn't see old data
        let store = DIContainer.shared.resolve(type: UserProfileStore.self)
        store.clear()
        
        // Navigation Reset: Ensure the next user starts on the Home tab
        selectedTab = .home

        flow = .auth
    }
}
