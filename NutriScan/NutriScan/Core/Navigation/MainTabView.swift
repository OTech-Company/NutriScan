//
//  MainTabView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

/// Composes the app's tabs. Lives in Core/Navigation because it's
/// app-level composition (it must know about Home + Profile), same
/// reasoning as RootCoordinatorView.
///
/// Each tab renders its feature's own "FlowView" (e.g. `HomeFlowView`),
/// which owns its own `AppRouter`/`NavigationStack`. This keeps each
/// tab's back-stack independent, so switching tabs never loses your
/// place in the other tab's navigation.
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeFlowView()
                .tabItem { Label("Home", systemImage: "house") }

            ProfileFlowView()
                .tabItem { Label("Profile", systemImage: "person") }
        }
    }
}
