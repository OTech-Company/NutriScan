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
                title: "Go to Sign In",
                action: onSignIn,
                isLoading: false
            )
            .padding(.horizontal, 20)
            
            // Resend Action
            if countdown > 0 {
                HStack(spacing: 6) {
                    Text("Resend email in")
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
                        Text("Didn't receive it?")
                            .font(Font.AppFont.textSecondary)
                            .foregroundColor(Color.VerificationPendingSemantic.instructionText)
                        
                        Text("Resend Verification Email.")
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
