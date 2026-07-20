//
//  VerificationPendingView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import SwiftUI

struct VerificationPendingView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel: VerificationPendingViewModel
    
    @State private var showResendSuccess = false
    @State private var showResendFailure = false
    @State private var errorMessage = ""
    
    init(email: String) {
        _viewModel = State(initialValue: VerificationPendingViewModel(email: email))
    }

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // MARK: Header
                    VerificationPendingHeaderSection(onBack: {
                        router.pop()
                    })

                    // MARK: Content
                    VerificationPendingContentSection(email: viewModel.email)
                    
                    // MARK: Actions
                    VerificationPendingActionsSection(
                        countdown: viewModel.countdown,
                        isLoading: viewModel.isLoading,
                        onSignIn: {
                            router.pop()
                        },
                        onResend: handleResend
                    )
                    .padding(.top, 32)
                }
            }
            .appAuthBackground()
            .navigationBarHidden(true)
            .ignoresSafeArea(edges: .top)
            
            // Success Resend Dialog Overlay
            if showResendSuccess {
                SuccessDialog(
                    title: "Verification Email Sent",
                    subtitle: viewModel.resendMessage
                ) {
                    showResendSuccess = false
                }
                .transition(.opacity)
                .zIndex(1)
            }
            
            // Failure Resend Dialog Overlay
            if showResendFailure {
                FailureDialog(
                    title: "Action Failed",
                    subtitle: errorMessage
                ) {
                    showResendFailure = false
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .onChange(of: viewModel.resendSuccess) { _, success in
            if success {
                withAnimation {
                    showResendSuccess = true
                }
            }
        }
        .onChange(of: viewModel.generalError) { _, error in
            if let error = error {
                errorMessage = error
                withAnimation {
                    showResendFailure = true
                }
            }
        }
    }
    
    private func handleResend() {
        Task {
            await viewModel.resendVerification()
        }
    }
}

#Preview {
    VerificationPendingView(email: "user@example.com")
        .environmentObject(AppRouter())
}

