//
//  SettingsFlowView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//


import SwiftUI

struct SettingsFlowView: View {
    @StateObject private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            // Main settings view created via Factory
            SettingsFactory.makeSettingsView()
                .navigationDestination(for: AnyRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}
