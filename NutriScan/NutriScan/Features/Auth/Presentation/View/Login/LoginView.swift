//
//  LoginView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

struct LoginView: View {
    private enum AlertDestination: String, Identifiable {
        case error
        var id: String { rawValue }
    }

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    @State private var alert: AlertDestination?
    @State private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    AuthHeaderView()
                    VStack(spacing: 0) {
                        
                        LoginFormFieldsSection(viewModel: viewModel)
                            .padding(.top, 24)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                router.push(AuthRoute.forgotPassword)
                            }) {
                                Text("Forgot Password?")
                                    .font(Font.AppFont.textSecondary)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.LoginSemantic.forgotPasswordText)
                            }
                        }
                        .padding(.top, 12)
                        
                        CustomPuffedButton(title: "Sign in", action: handleSignIn, isLoading: viewModel.isLoading)
                            .padding(.top, 24)
                        
                        AuthDivider()
                            .padding(.top, 32)
                        
                        HStack(spacing: 8) {
                            SocialLoginButton(iconName: "facebook", action: {})
                            SocialLoginButton(iconName: "google", action: {})
                            SocialLoginButton(iconName: "instagram", action: {})
                        }
                        .padding(.top, 24)
                        
                        Spacer(minLength: 40)
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .font(Font.AppFont.textSecondary)
                                .foregroundColor(Color.LoginSemantic.footerText)
                            
                            Button(action: {
                                router.push(AuthRoute.register)
                            }) {
                                Text("Sign Up.")
                                    .font(Font.AppFont.textSecondary)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.LoginSemantic.footerLink)
                                    .underline()
                            }
                        }
                        .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .appAuthBackground()
            .scrollDismissesKeyboard(.interactively)
            .navigationBarHidden(true)
            .ignoresSafeArea(edges: .top)
            
        }
        .onChange(of: viewModel.generalError) { _, error in
            if error != nil {
                alert = .error
            }
        }
        .customAlert(
            item: $alert,
            config: { _ in
                CustomAlertConfig(
                    type: .error,
                    title: "Login Failed",
                    message: viewModel.generalError ?? "An unknown error occurred",
                    primaryButton: CustomAlertButton("Try Again")
                )
            },
            primaryAction: { _ in viewModel.generalError = nil }
        )
    }

    private func handleSignIn() {
        Task {
            let success = await viewModel.signIn()
            if success {
                let isPending = UserDefaults.standard.bool(forKey: "isPendingProfileSetup_\(viewModel.email.value)")
                flowCoordinator.didAuthenticate(isPendingSetup: isPending, email: viewModel.email.value)
            } else if viewModel.isEmailUnverified {
                router.push(AuthRoute.verificationPending(email: viewModel.email.value))
                viewModel.isEmailUnverified = false
            }
        }
    }
}
