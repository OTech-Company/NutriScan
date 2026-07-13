//
//  HomeFlowView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

/// Owns the Home tab's own `NavigationStack` + `AppRouter`. Because
/// this router is scoped to the tab (not shared with Profile's tab),
/// pushing screens in Home never affects Profile's back-stack, and
/// vice versa.
struct HomeFlowView: View {
    @StateObject private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: AnyRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}