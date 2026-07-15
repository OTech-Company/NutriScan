//
//  RegisterView.swift
//  NutriScan
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @EnvironmentObject private var router: AppRouter

    @State private var viewModel = RegisterViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // MARK: Header
                RegisterHeaderSection()

                // MARK: Form Fields
                RegisterFormFieldsSection(viewModel: viewModel)
                    .padding(.top, 24)

                Spacer(minLength: 32)

                // MARK: Sign Up Button
                RegisterSignUpButtonSection(
                    onSignUp: handleSignUp,
                    onSignIn: { router.pop() },
                    isLoading: viewModel.isLoading
                )
                .padding(.top, 12)
            }
        }
        .appAuthBackground()
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Sign Up
    private func handleSignUp() {
        Task {
            let success = await viewModel.signUp()
            if success {
                flowCoordinator.didAuthenticate()
            }
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AppFlowCoordinator())
        .environmentObject(AppRouter())
}
