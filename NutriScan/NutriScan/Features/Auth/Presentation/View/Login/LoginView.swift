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

    @State private var viewModel = LoginViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                AuthHeaderView()
                VStack(spacing: 0) {
                    
                    LoginFormFieldsSection(viewModel: viewModel)
                        .padding(.top, 24)
                    
                    CustomPuffedButton(title: "Sign in", action: handleSignIn, isLoading: viewModel.isLoading)
                        .padding(.top, 32)
                    
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
                            .foregroundColor(Color.Gray.gray1000)
                        
                        Button(action: {
                            router.push(AuthRoute.register)
                        }) {
                            Text("Sign Up.")
                                .font(Font.AppFont.textSecondary)
                                .fontWeight(.bold)
                                .foregroundColor(Color.Teal.teal1000)
                                .underline()
                        }
                    }
                    .padding(.bottom, 32)
                }
                .padding(.horizontal, 20)
            }
        }
        .appAuthBackground()
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
    }

    private func handleSignIn() {
        Task {
            let success = await viewModel.signIn()
            if success {
                flowCoordinator.didAuthenticate()
            }
        }
    }
}
