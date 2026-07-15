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
                // 1. Header Section
                headerSection
                
                // 2. Form & Actions Section
                VStack(spacing: 0) { // Removed default spacing to control exact padding per element
                    
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
                    .padding(.top, 24) // Space between header bottom and first field
                    
                    CustomPuffedButton(title: "Sign in") {
                        // On real success from your AuthUseCase:
                        flowCoordinator.didAuthenticate()
                    }
                    .padding(.top, 32) // Substantial gap as seen in Figma
                    
                    // 3. Divider
                    HStack {
                        Rectangle()
                            .fill(Color.Gray.gray500)
                            .frame(height: 1)
                        Text("OR")
                            .font(Font.AppFont.textCaption)
                            .foregroundColor(Color.Gray.gray800)
                            .padding(.horizontal, 12)
                        Rectangle()
                            .fill(Color.Gray.gray500)
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 40) // Breathing room above divider
                    
                    // 4. Social Login
                    HStack(spacing: 24) { // Wider spacing between buttons
                        SocialLoginButton(iconName: "f.cursive", action: {})
                        SocialLoginButton(iconName: "g.circle", action: {})
                        SocialLoginButton(iconName: "camera", action: {})
                    }
                    .padding(.top, 24) // Gap below divider
                    
                    Spacer()
                    
                    // 5. Footer
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
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(spacing: 48) { // Exact gap between logo and text
            Image("logo white")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.top, 128) // Account for safe area + padding
            
            Text("Sign In")
                .font(Font.AppFont.title2)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 36)
        .background(Color.Teal.teal800)
        .clipShape(
            UnevenRoundedRectangle(
                bottomLeadingRadius: 32,
                bottomTrailingRadius: 32
            )
        )
        .shadow(color: colorScheme == .dark ? Color.Teal.teal600.opacity(0.2) : .clear, radius: 10, x: 0, y: 5)
    }
}

// MARK: - Reusable Social Login Button

struct SocialLoginButton: View {
    let iconName: String
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(colorScheme == .light ? Color.Teal.teal1400 : .white)
                .frame(width: 56, height: 56)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(colorScheme == .light ? Color.Gray.gray500 : Color.Teal.teal600, lineWidth: 1)
                )
        }
    }
}
