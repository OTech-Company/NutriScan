//
//  VerificationPendingView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import SwiftUI

struct VerificationPendingView: View {
    private enum AlertDestination: String, Identifiable {
        case success
        case error
        var id: String { rawValue }
    }

    @EnvironmentObject private var router: AppRouter
    @State private var viewModel: VerificationPendingViewModel
    
    @State private var alert: AlertDestination?
    
    init(viewModel: VerificationPendingViewModel) {
        _viewModel = State(wrappedValue: viewModel)
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
                            router.popToRoot()
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
                alert = .success
            }
        }
        .onChange(of: viewModel.generalError) { _, error in
            if error != nil {
                alert = .error
            }
        }
        .customAlert(item: $alert, config: { alert in
            switch alert {
            case .success:
                return CustomAlertConfig(
                    type: .success,
                    title: LocalizationKeys.Auth.VerificationPending.sentTitle.localized,
                    message: viewModel.resendMessage,
                    primaryButton: CustomAlertButton(LocalizationKeys.Common.continueAction.localized)
                )
            case .error:
                return CustomAlertConfig(
                    type: .error,
                    title: LocalizationKeys.Common.actionFailed.localized,
                    message: viewModel.generalError ?? LocalizationKeys.Common.unknownError.localized,
                    primaryButton: CustomAlertButton(LocalizationKeys.Common.tryAgain.localized)
                )
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
    AuthFactory.makeVerificationPendingView(email: "user@example.com")
        .environmentObject(AppRouter())
}
