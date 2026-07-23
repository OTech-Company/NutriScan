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
    
    @State private var activeAlert: ActiveAlert = .none
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
            
        }
        .onChange(of: viewModel.resendSuccess) { _, success in
            if success {
                activeAlert = .success
            }
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
                    title: "Verification Email Sent",
                    description: viewModel.resendMessage,
                    primaryButtonTitle: "Continue",
                    primaryButtonColor: Color.Teal.teal1000
                )
            case .error:
                return CustomAlertConfig(
                    type: .error,
                    title: "Action Failed",
                    description: errorMessage,
                    primaryButtonTitle: "Try Again",
                    primaryButtonColor: Color.Red.red500
                )
            default:
                return CustomAlertConfig(type: .warning, title: "", description: "")
            }
        }, primaryAction: { alert in
            if alert == .success {
                viewModel.resendSuccess = false
            } else if alert == .error {
                viewModel.generalError = nil
            }
        })
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

