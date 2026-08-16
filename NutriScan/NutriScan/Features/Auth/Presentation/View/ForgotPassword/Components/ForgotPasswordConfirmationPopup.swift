//
//  ForgotPasswordConfirmationPopup.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 18/07/2026.
//

import SwiftUI

struct ForgotPasswordConfirmationPopup: View {
    @Environment(\.colorScheme) var colorScheme
    @Bindable var viewModel: ForgotPasswordViewModel

    var onSendLink: () -> Void
    var onResendLink: () -> Void
    var onClose: () -> Void

    var body: some View {
        ZStack {
            // MARK: - Dimmed Background Overlay
            Color.Teal.teal1600.opacity(0.75)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }

            VStack(spacing: 0) {

                // MARK: - Popup Card
                VStack(alignment: .leading, spacing: 0) {
                    if viewModel.popupState == .enterEmail {
                        // MARK: Title
                        Text(LocalizationKeys.Auth.ForgotPassword.resetTitle.localized)
                            .font(Font.AppFont.title1)
                            .foregroundColor(Color.ForgotPasswordSemantic.confirmationTitle)
                            .padding(.top, 8)

                        // MARK: Description
                        Text(LocalizationKeys.Auth.ForgotPassword.resetDescription.localized)
                            .font(Font.AppFont.textSecondary)
                            .foregroundColor(Color.ForgotPasswordSemantic.confirmationSubtitle)
                            .lineSpacing(4)
                            .padding(.top, 8)

                        // MARK: Email Input Field
                        CustomTextField(
                            title: LocalizationKeys.Auth.ForgotPassword.emailTitle.localized,
                            leadingIcon: "envelope",
                            errorMessage: viewModel.email.error,
                            placeHolder: LocalizationKeys.Auth.ForgotPassword.emailPlaceholder.localized,
                            textFieldValue: $viewModel.email.value,
                            state: $viewModel.email.state
                        )
                        .padding(.top, 20)
                        .onChange(of: viewModel.email.value) {
                            viewModel.validateEmail()
                        }

                        // MARK: Action Button
                        CustomPuffedButton(
                            title: LocalizationKeys.Auth.ForgotPassword.sendResetLink.localized,
                            action: onSendLink,
                            isLoading: viewModel.isLoading
                        )
                        .padding(.top, 24)
                    } else if viewModel.popupState == .emailSent {
                        // MARK: Illustration
                        Image(colorScheme == .light ? "forgot_pass_confirm" : "forgot_pass_confirm_dark")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .padding(.all, -26)
                            .customTealShadow()

                        // MARK: Title
                        Text(LocalizationKeys.Auth.ForgotPassword.resetLinkSentTitle.localized)
                            .font(Font.AppFont.title1)
                            .foregroundColor(Color.ForgotPasswordSemantic.confirmationTitle)
                            .padding(.top, 12)

                        // MARK: Subtitle
                        Text("\(LocalizationKeys.Auth.ForgotPassword.resetLinkSentDesc.localized)\n\(viewModel.email.value)\n\n\(LocalizationKeys.Auth.ForgotPassword.checkInbox.localized)")
                            .font(Font.AppFont.textPrimary)
                            .foregroundColor(Color.ForgotPasswordSemantic.confirmationSubtitle)
                            .lineSpacing(4)
                            .padding(.top, 8)

                        // MARK: Resend Button
                        CustomPuffedButton(
                            title: LocalizationKeys.Auth.ForgotPassword.resendLink.localized,
                            action: onResendLink,
                            isLoading: viewModel.isLoading
                        )
                        .padding(.top, 20)
                    }
                }
                .padding(20)
                .background(Color.ForgotPasswordSemantic.confirmationCardBackground)
                .cornerRadius(24)
                .padding(.horizontal, 24)

                // MARK: - Close Button
                Button(action: onClose) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .frame(width: 64, height: 64)
                            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)

                        Image(systemName: "xmark")
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.Teal.teal1000)
                    }
                }
                .padding(.top, 32)

            }
        }
    }
}

#Preview {
    ForgotPasswordConfirmationPopup(
        viewModel: AuthFactory.makeForgotPasswordViewModel(),
        onSendLink: {},
        onResendLink: {},
        onClose: {}
    )
}
