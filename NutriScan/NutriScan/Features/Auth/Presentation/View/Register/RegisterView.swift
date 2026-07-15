//
//  RegisterView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @EnvironmentObject private var router: AppRouter
    @Environment(\.colorScheme) var colorScheme

    @State private var viewModel = RegisterViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            // Background — mirrors Login screen
            (colorScheme == .light ? Color.Teal.teal100 : Color.Teal.teal1600)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: Header
                    RegisterHeaderSection()

                    // MARK: Form Fields
                    RegisterFormFieldsSection(
                        email: $viewModel.email,
                        password: $viewModel.password,
                        confirmPassword: $viewModel.confirmPassword
                    )
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
        }
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
