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
                    
                    // MARK: Reset Options
                    ForgotPasswordOptionsSection(viewModel: viewModel)
                        .padding(.top, 32)
                    
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
                    recipient: maskedRecipient,
                    onResend: handleReset,
                    onClose: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showConfirmation = false
                            router.pop() // Pop screen when closed/dismissed as per success flow
                        }
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .zIndex(1)
            }
        }
    }
    
    private var maskedRecipient: String {
        switch viewModel.selectedOption {
        case .email:
            return "elem*******221b@gmail.com"
        case .twoFactor:
            return "your 2FA Authenticator app"
        case .googleAuth:
            return "your Google Authenticator app"
        case .sms:
            return "+1 (555) *******98"
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
