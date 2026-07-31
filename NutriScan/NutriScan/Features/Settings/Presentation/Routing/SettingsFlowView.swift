//
//  SettingsFlowView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//


import SwiftUI

struct SettingsFlowView: View {
    @StateObject private var router = AppRouter()
    @State private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack(path: $router.path) {
            // Your main settings list/dashboard view
            SettingsView()
                .navigationDestination(for: AnyRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}
