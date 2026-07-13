//
//  AuthFlowView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

struct AuthFlowView: View {
    @StateObject private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            LoginView()
                .navigationDestination(for: AnyRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}