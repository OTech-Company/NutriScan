//
//  RegisterView.swift
//  NutriScan
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @EnvironmentObject private var router: AppRouter
    private var toastManager = ToastManager.shared

    @State private var viewModel = RegisterViewModel()
    @State private var showSuccess = false

    var body: some View {
        ZStack {
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
            
            if showSuccess {
                SuccessDialog(
                    title: "Registration Success",
                    subtitle: "Your account has been created successfully."
                ) {
                    showSuccess = false
                    flowCoordinator.didAuthenticate()
                }
                .transition(.opacity)
            }
        }
        .onChange(of: viewModel.generalError) { _, newValue in
            if let error = newValue {
                toastManager.show(Toast(style: .error, message: error))
            }
        }
    }

    // MARK: - Sign Up
    private func handleSignUp() {
        Task {
            let success = await viewModel.signUp()
            if success {
                withAnimation {
                    showSuccess = true
                }
            }
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AppFlowCoordinator())
        .environmentObject(AppRouter())
}
