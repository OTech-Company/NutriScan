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
                        onReset: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                viewModel.startResetFlow()
                            }
                        },
                        isLoading: viewModel.isLoading
                    )
                }
            }
            .appAuthBackground()
            .navigationBarHidden(true)
            .ignoresSafeArea(edges: .top)
            
            // Custom Confirmation Overlay
            if viewModel.popupState != .hidden {
                ForgotPasswordConfirmationPopup(
                    viewModel: viewModel,
                    onSendLink: handleReset,
                    onResendLink: handleReset,
                    onClose: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            let wasSent = viewModel.popupState == .emailSent
                            viewModel.closePopup()
                            if wasSent {
                                router.pop()
                            }
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
            _ = await viewModel.resetPassword()
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AppRouter())
}
