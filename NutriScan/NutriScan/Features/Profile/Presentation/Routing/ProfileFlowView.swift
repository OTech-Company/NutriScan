//
//  ProfileFlowView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

struct ProfileFlowView: View {
    @StateObject private var router = AppRouter()
    
    @State private var profileViewModel: ProfileViewModel
    
    init() {
        let repository = NetworkProfileRepository()
        let useCase = GetProfileUseCase(repository: repository)
        self._profileViewModel = State(initialValue: ProfileViewModel(getProfileUseCase: useCase))
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            ProfileView(viewModel: profileViewModel)
                .navigationDestination(for: AnyRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}
