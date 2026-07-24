//
//  RegisterView.swift
//  NutriScan
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel = RegisterViewModel()
    @State private var activeAlert: ActiveAlert = .none
    @State private var errorMessage = ""

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
            .scrollDismissesKeyboard(.interactively)
            .navigationBarHidden(true)
            .ignoresSafeArea(edges: .top)
        }
        .onChange(of: viewModel.generalError) { _, error in
            if let error = error {
                errorMessage = error
                activeAlert = .error
            }
        }
        .customAlert(activeAlert: $activeAlert, config: { alert in
            switch alert {
            case .success:
                return CustomAlertConfig(
                    type: .success,
                    title: "Registration Success",
                    description: "Your account has been created successfully.",
                    primaryButtonTitle: "Continue",
                    primaryButtonColor: Color.Teal.teal1000
                )
            case .error:
                return CustomAlertConfig(
                    type: .error,
                    title: "Registration Failed",
                    description: errorMessage,
                    primaryButtonTitle: "Try Again",
                    primaryButtonColor: Color.Red.red500
                )
            default:
                return CustomAlertConfig(type: .warning, title: "", description: "")
            }
        }, primaryAction: { alert in
            if alert == .success {
                router.push(AuthRoute.verificationPending(email: viewModel.email.value))
            } else if alert == .error {
                viewModel.generalError = nil
            }
        })
    }

    // MARK: - Sign Up
    private func handleSignUp() {
        Task {
            let success = await viewModel.signUp()
            if success {
                activeAlert = .success
            }
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AppFlowCoordinator())
        .environmentObject(AppRouter())
}
