//
//  RootCoordinatorView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

/// The ONLY place in the entire app that wires top-level flows together.
///
/// You touch this file once, when the app is created. You never touch
/// it again when adding new screens *within* an existing flow (those
/// register themselves via `Route`/`AnyRoute`), and you only touch it
/// when adding a brand new *top-level flow* (rare — e.g. a "force
/// update" screen).
///
/// Each flow below (Splash, Onboarding, Auth, Main) owns its own
/// internal navigation — this view just decides which one is visible.
struct RootCoordinatorView: View {
    @StateObject private var flowCoordinator = AppFlowCoordinator()

    var body: some View {
        Group {
            switch flowCoordinator.flow {
            case .splash:
                SplashView()
            case .onboarding:
                OnboardingFlowView()
            case .auth:
                AuthFlowView()
            case .main:
                MainTabView()
            }
        }
        .environmentObject(flowCoordinator)
        .animation(.default, value: flowCoordinator.flow)
    }
}

