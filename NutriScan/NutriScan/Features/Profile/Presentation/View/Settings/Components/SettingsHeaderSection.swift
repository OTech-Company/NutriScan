//
//  SettingsHeaderSection.swift
//  NutriScan
//

import SwiftUI

// MARK: - Settings Header Section
struct SettingsHeaderSection: View {
    var onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Back Button
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.SettingsSemantic.backButtonIcon)
                    .frame(width: 44, height: 44)
                    .background(Color.SettingsSemantic.backButtonBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.SettingsSemantic.backButtonBorder, lineWidth: 1)
                    )
            }
            .padding(.top, 64)

            // Text Block
            VStack(alignment: .leading, spacing: 8) {
                Text("App Settings")
                    .font(Font.AppFont.plusJakartaSansBold28)
                    .foregroundColor(Color.SettingsSemantic.headerTitle)

                Text("Change application settings here")
                    .font(Font.AppFont.lexendDecaMedium16)
                    .foregroundColor(Color.SettingsSemantic.headerSubtitle)
            }
            .padding(.bottom, 28)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.SettingsSemantic.headerBackground)
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
    SettingsHeaderSection(onBack: {})
        .background(Color.SettingsSemantic.screenBackground)
}
