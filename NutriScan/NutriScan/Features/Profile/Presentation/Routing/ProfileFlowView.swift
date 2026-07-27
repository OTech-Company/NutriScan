//
//  ProfileFlowView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

struct ProfileFlowView: View {
    @StateObject private var router = AppRouter()
    @State private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack(path: $router.path) {
            ProfileView(viewModel: viewModel)
                .navigationDestination(for: AnyRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}
