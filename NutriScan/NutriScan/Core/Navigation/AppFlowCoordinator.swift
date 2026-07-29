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

    // Replace these with real checks (Keychain token, UserDefaults flag, etc.)
    // NOTE: key matches @AppStorage("hasSeenOnboarding") used in OnboardingScreen —
    // keep these in sync, or better, centralize the key name as a constant.
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
        // e.g. check the fetched User entity for required profile fields,
        // or a dedicated flag from your ProfileRepository
        UserDefaults.standard.bool(forKey: "hasCompletedProfileSetup")
    }

    /// Called once, e.g. after Splash finishes its minimum display time
    /// and/or any startup checks (session validation, remote config, etc).
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
                // If it fails (e.g. no internet), we still let them into the main app
                // where the Home screen can handle the empty cache gracefully.
                _ = try? await fetchAndCacheProfileUseCase.execute()
                flow = .main
            }
        }
    }

    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        flow = .auth
    }

    func didAuthenticate(isPendingSetup: Bool = false, email: String? = nil) {
        if isPendingSetup {
            UserDefaults.standard.set(false, forKey: "hasCompletedProfileSetup")
            if let email = email {
                UserDefaults.standard.set(email, forKey: "currentSetupEmail")
            }
            flow = .profileSetup
        } else {
            UserDefaults.standard.set(true, forKey: "hasCompletedProfileSetup")
            flow = .main
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

        flow = .auth
    }
}
