//
//  AccountRestorationHeaderSection.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import SwiftUI

struct AccountRestorationHeaderSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()
                .frame(height: 64)

            // Text Block
            VStack(alignment: .leading, spacing: 8) {
                Text("Restore Account")
                    .font(Font.AppFont.plusJakartaSansBold28)
                    .foregroundColor(Color.AccountRestorationSemantic.headerTitle)
                
                Text("Your account is scheduled for deletion.")
                    .font(Font.AppFont.lexendDecaMedium16)
                    .foregroundColor(Color.AccountRestorationSemantic.headerSubtitle)
            }
            .padding(.bottom, 28)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.AccountRestorationSemantic.headerBackground)
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
    AccountRestorationHeaderSection()
}
