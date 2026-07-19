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

    // Replace these with real checks (Keychain token, UserDefaults flag, etc.)
    // NOTE: key matches @AppStorage("hasSeenOnboarding") used in OnboardingScreen —
    // keep these in sync, or better, centralize the key name as a constant.
    private var hasCompletedOnboarding: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    }

    private var isAuthenticated: Bool {
        // e.g. check Keychain for a valid session token
        false
    }

    private var hasCompletedProfileSetup: Bool {
        // e.g. check the fetched User entity for required profile fields,
        // or a dedicated flag from your ProfileRepository
        UserDefaults.standard.bool(forKey: "hasCompletedProfileSetup")
    }
    

    /// Called once, e.g. after Splash finishes its minimum display time
    /// and/or any startup checks (session validation, remote config, etc).
    func finishSplash() {
        if !hasCompletedOnboarding {
            flow = .onboarding
        } else if !isAuthenticated {
            flow = .auth
        } else if !hasCompletedProfileSetup {
            flow = .profileSetup
        } else {
            flow = .main
        }
    }

    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        flow = .auth
    }

    func didAuthenticate() {
        flow = hasCompletedProfileSetup ? .main : .profileSetup
    }
    
    func finishProfileSetup() {
        UserDefaults.standard.set(true, forKey: "hasCompletedProfileSetup")
        flow = .main
    }
    
    func logout() {
        flow = .auth
    }
}
