//
//  VerificationPendingActionsSection.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import SwiftUI

struct VerificationPendingActionsSection: View {
    let countdown: Int
    let isLoading: Bool
    var onSignIn: () -> Void
    var onResend: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            CustomPuffedButton(
                title: LocalizationKeys.Auth.VerificationPending.goToSignIn.localized,
                action: onSignIn,
                isLoading: false
            )
            .padding(.horizontal, 20)

            // Resend Action
            if countdown > 0 {
                HStack(spacing: 6) {
                    Text(LocalizationKeys.Auth.VerificationPending.resendEmailIn.localized)
                        .font(Font.AppFont.textSecondary)
                        .foregroundColor(Color.VerificationPendingSemantic.instructionText)
                    Text("\(countdown)s")
                        .font(Font.AppFont.textSecondary)
                        .fontWeight(.bold)
                        .foregroundColor(Color.VerificationPendingSemantic.timerText)
                }
                .padding(.top, 8)
            } else {
                Button(action: onResend) {
                    HStack(spacing: 4) {
                        Text(LocalizationKeys.Auth.VerificationPending.didNotReceive.localized)
                            .font(Font.AppFont.textSecondary)
                            .foregroundColor(Color.VerificationPendingSemantic.instructionText)

                        Text(LocalizationKeys.Auth.VerificationPending.resendEmail.localized)
                            .font(Font.AppFont.textSecondary)
                            .fontWeight(.bold)
                            .foregroundColor(Color.VerificationPendingSemantic.linkText)
                            .underline()
                    }
                }
                .disabled(isLoading)
                .padding(.top, 8)
            }
        }
    }
}

#Preview {
    VerificationPendingActionsSection(
        countdown: 0,
        isLoading: false,
        onSignIn: {},
        onResend: {}
    )
}
