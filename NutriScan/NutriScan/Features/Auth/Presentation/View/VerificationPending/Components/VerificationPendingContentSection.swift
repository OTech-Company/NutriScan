//
//  VerificationPendingContentSection.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import SwiftUI

struct VerificationPendingContentSection: View {
    let email: String

    var body: some View {
        VStack(spacing: 32) {

            // Premium Glowing Mail Icon
            ZStack {
                Circle()
                    .fill(Color.VerificationPendingSemantic.iconCircleOuter)
                    .frame(width: 130, height: 130)

                Circle()
                    .fill(Color.VerificationPendingSemantic.iconCircleMiddle)
                    .frame(width: 105, height: 105)

                Circle()
                    .fill(Color.VerificationPendingSemantic.iconCircleInner)
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.VerificationPendingSemantic.iconCircleInner.opacity(0.4), radius: 10, x: 0, y: 5)

                Image(systemName: "envelope.badge.shield.half.filled")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(Color.VerificationPendingSemantic.iconForeground)
            }
            .padding(.top, 40)

            // Instructions Text
            VStack(spacing: 12) {
                Text(LocalizationKeys.Auth.VerificationPending.linkSentTo.localized)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.VerificationPendingSemantic.instructionText)

                Text(email)
                    .font(Font.AppFont.subtitle1)
                    .fontWeight(.bold)
                    .foregroundColor(Color.VerificationPendingSemantic.emailText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Text(LocalizationKeys.Auth.VerificationPending.instructions.localized)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.VerificationPendingSemantic.instructionText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .lineSpacing(4)
            }
        }
    }
}

#Preview {
    VerificationPendingContentSection(email: "user@example.com")
}
