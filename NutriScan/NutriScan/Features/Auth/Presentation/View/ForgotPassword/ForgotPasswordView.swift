//
//  ForgotPasswordView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 16/07/2026.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel = ForgotPasswordViewModel()
    @State private var showConfirmation = false

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: Header
                    ForgotPasswordHeaderSection(onBack: {
                        router.pop()
                    })
                    
                    // MARK: Email Input
                    CustomTextField(
                        title: "Email Address",
                        leadingIcon: "envelope",
                        errorMessage: viewModel.email.error,
                        placeHolder: "elementary221b@gmail.com",
                        textFieldValue: $viewModel.email.value,
                        state: $viewModel.email.state
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                    .onChange(of: viewModel.email.value) {
                        viewModel.validateEmail()
                    }
                    
                    Spacer(minLength: 40)
                    
                    // MARK: Action Button
                    ForgotPasswordResetButtonSection(
                        onReset: handleReset,
                        isLoading: viewModel.isLoading
                    )
                }
            }
            .appAuthBackground()
            .navigationBarHidden(true)
            .ignoresSafeArea(edges: .top)
            
            // Custom Confirmation Overlay
            if showConfirmation {
                ForgotPasswordConfirmationPopup(
                    recipient: viewModel.email.value,
                    onResend: handleReset,
                    onClose: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showConfirmation = false
                            router.pop()
                        }
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .zIndex(1)
            }
        }
    }
    

    private func handleReset() {
        Task {
            let success = await viewModel.resetPassword()
            if success {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    showConfirmation = true
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AppRouter())
}
