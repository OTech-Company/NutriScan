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
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
            }
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
