//
//  RegisterView.swift
//  NutriScan
//

import SwiftUI

struct RegisterView: View {
    private enum AlertDestination: String, Identifiable {
        case success
        case error
        var id: String { rawValue }
    }

    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel: RegisterViewModel
    @State private var alert: AlertDestination?

    init(viewModel: RegisterViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: Header
                    RegisterHeaderSection()

                    // MARK: Form Fields
                    RegisterFormFieldsSection(viewModel: viewModel)
                        .padding(.top, 24)

                    Spacer(minLength: 32)

                    // MARK: Sign Up Button
                    RegisterSignUpButtonSection(
                        onSignUp: handleSignUp,
                        onSignIn: { router.pop() },
                        isLoading: viewModel.isLoading
                    )
                    .padding(.top, 12)
                }
            }
            .appAuthBackground()
            .scrollDismissesKeyboard(.interactively)
            .navigationBarHidden(true)
            .ignoresSafeArea(edges: .top)
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
                    title: LocalizationKeys.Auth.Register.successTitle.localized,
                    message: LocalizationKeys.Auth.Register.successDescription.localized,
                    primaryButton: CustomAlertButton(LocalizationKeys.Common.continueAction.localized)
                )
            case .error:
                return CustomAlertConfig(
                    type: .error,
                    title: LocalizationKeys.Auth.Register.failedTitle.localized,
                    message: viewModel.generalError ?? LocalizationKeys.Common.unknownError.localized,
                    primaryButton: CustomAlertButton(LocalizationKeys.Common.tryAgain.localized)
                )
            }
        }, primaryAction: { alert in
            if alert == .success {
                router.push(AuthRoute.verificationPending(email: viewModel.email.value))
            } else if alert == .error {
                viewModel.generalError = nil
            }
        })
    }

    // MARK: - Sign Up
    private func handleSignUp() {
        Task {
            let success = await viewModel.signUp()
            if success {
                alert = .success
            }
        }
    }
}

#Preview {
    AuthFactory.makeRegisterView()
        .environmentObject(AppFlowCoordinator())
        .environmentObject(AppRouter())
}
