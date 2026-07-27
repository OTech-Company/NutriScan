//
//  ForgotPasswordHeaderSection.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 16/07/2026.
//

import SwiftUI

struct ForgotPasswordHeaderSection: View {
    var onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Back Button
            BackButton(action: onBack, style: .onTeal)
                .padding(.top, 64)
            
            // Text Block
            VStack(alignment: .leading, spacing: 8) {
                Text("Forgot Password?")
                    .font(Font.AppFont.plusJakartaSansBold28)
                    .foregroundColor(Color.ForgotPasswordSemantic.headerTitle)
                
                Text("Then let's submit password reset.")
                    .font(Font.AppFont.lexendDecaMedium16)
                    .foregroundColor(Color.ForgotPasswordSemantic.headerSubtitle)
            }
            .padding(.bottom, 28)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.Teal.teal800)
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
    ForgotPasswordHeaderSection(onBack: {})
        .background(Color.Teal.teal100)
}
