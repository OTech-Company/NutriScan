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
    @Environment(\.colorScheme) var colorScheme

    @State private var email = ""
    @State private var password = ""
    @State private var emailState: TextFieldState = .normal
    @State private var passwordState: TextFieldState = .normal

    var body: some View {
        ZStack(alignment: .top) {
            // Background
            (colorScheme == .light ? Color.Teal.teal100 : Color.Teal.teal1600)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                AuthHeaderView()
                
                VStack(spacing: 0) {
                    
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Email Address",
                            leadingIcon: "envelope",
                            placeHolder: "elementary221b@gmail.com",
                            textFieldValue: $email,
                            state: $emailState
                        )
                        
                        CustomTextField(
                            title: "Password",
                            leadingIcon: "lock",
                            isPassword: true,
                            placeHolder: "*****************",
                            textFieldValue: $password,
                            state: $passwordState
                        )
                    }
                    .padding(.top, 24)
                    
                    CustomPuffedButton(title: "Sign in") {
                        // On real success from your AuthUseCase:
                        flowCoordinator.didAuthenticate()
                    }
                    .padding(.top, 32)
                    
                    AuthDivider()
                        .padding(.top, 40)
                    
                    HStack(spacing: 24) {
                        SocialLoginButton(iconName: "facebook", action: {})
                        SocialLoginButton(iconName: "google", action: {})
                        SocialLoginButton(iconName: "instagram", action: {})
                    }
                    .padding(.top, 24)
                    
                    Spacer()
                    
                    // Footer Section
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(Font.AppFont.textSecondary)
                            .foregroundColor(colorScheme == .light ? Color.Gray.gray1000 : Color.Gray.gray400)
                        
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
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
    }
}


