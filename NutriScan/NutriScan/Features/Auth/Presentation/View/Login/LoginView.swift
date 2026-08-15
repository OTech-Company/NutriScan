//
//  LoginView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    @State private var activeAlert: ActiveAlert = .none
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
                                Text(LocalizationKeys.Auth.Login.forgotPassword.localized)
                                    .font(Font.AppFont.textSecondary)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.LoginSemantic.forgotPasswordText)
                            }
                        }
                        .padding(.top, 12)
                        
                        CustomPuffedButton(
                            title: LocalizationKeys.Auth.Login.signIn.localized,
                            action: handleSignIn,
                            isLoading: viewModel.isLoading
                        )
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
                            Text(LocalizationKeys.Auth.Login.noAccount.localized)
                                .font(Font.AppFont.textSecondary)
                                .foregroundColor(Color.LoginSemantic.footerText)
                            
                            Button(action: {
                                router.push(AuthRoute.register)
                            }) {
                                Text(LocalizationKeys.Auth.Login.signUp.localized)
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
                activeAlert = .error
            }
        }
        .customAlert(activeAlert: $activeAlert, config: { alert in
            switch alert {
            case .error:
                return CustomAlertConfig(
                    type: .error,
                    title: LocalizationKeys.Auth.Login.failedTitle.localized,
                    description: viewModel.generalError ?? LocalizationKeys.Auth.Login.failedUnknown.localized,
                    primaryButtonTitle: LocalizationKeys.Auth.Login.tryAgain.localized,
                    primaryButtonColor: Color.Red.red500
                )
            default:
                return CustomAlertConfig(
                    type: .error,
                    title: LocalizationKeys.Common.error.localized,
                    description: viewModel.generalError ?? ""
                )
            }
        }, primaryAction: { _ in
            viewModel.generalError = nil
        })
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
