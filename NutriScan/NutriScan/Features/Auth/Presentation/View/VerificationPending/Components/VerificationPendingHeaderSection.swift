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
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.VerificationPendingSemantic.backButtonIcon)
                    .frame(width: 44, height: 44)
                    .background(Color.VerificationPendingSemantic.backButtonBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.VerificationPendingSemantic.backButtonBorder, lineWidth: 1)
                    )
            }
            .padding(.top, 64)
            
            // Text Block
            VStack(alignment: .leading, spacing: 8) {
                Text("Verify Your Email")
                    .font(Font.AppFont.plusJakartaSansBold28)
                    .foregroundColor(Color.VerificationPendingSemantic.headerTitle)
                
                Text("Confirm it's you to start scanning.")
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
