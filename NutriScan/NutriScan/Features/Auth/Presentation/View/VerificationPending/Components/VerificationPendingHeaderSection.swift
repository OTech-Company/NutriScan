//
//  VerificationPendingHeaderSection.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import SwiftUI

struct VerificationPendingHeaderSection: View {
    var onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Back Button
            BackButton(action: onBack, style: .onTeal)
                .padding(.top, 64)

            // Text Block
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizationKeys.Auth.VerificationPending.headerTitle.localized)
                    .font(Font.AppFont.plusJakartaSansBold28)
                    .foregroundColor(Color.VerificationPendingSemantic.headerTitle)

                Text(LocalizationKeys.Auth.VerificationPending.headerSubtitle.localized)
                    .font(Font.AppFont.lexendDecaMedium16)
                    .foregroundColor(Color.VerificationPendingSemantic.headerSubtitle)
            }
            .padding(.bottom, 28)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.VerificationPendingSemantic.headerBackground)
        .clipShape(
            UnevenRoundedRectangle(
                bottomLeadingRadius: 32,
                bottomTrailingRadius: 32
            )
        )
        .customTealShadow()
    }
}

#Preview {
    VerificationPendingHeaderSection(onBack: {})
        .background(Color.Teal.teal100)
}
