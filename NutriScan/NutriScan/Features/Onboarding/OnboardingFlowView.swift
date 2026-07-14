//
//  OnboardingFlowView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

/// Owns onboarding's own `NavigationStack` + `AppRouter`, exactly like
/// `RootCoordinatorView` does for the whole app, but scoped to this
/// one flow. This is what makes each flow's back-stack independent.
struct OnboardingFlowView: View {
    @StateObject private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            OnboardingScreen()
                .navigationDestination(for: AnyRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}