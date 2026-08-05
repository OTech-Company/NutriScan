//
//  SettingsHeaderSection.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import SwiftUI

// MARK: - Settings Header Section
struct SettingsHeaderSection: View {
    var title: String? = "App Settings"
    var subtitle: String? = "Change application settings here"
    var onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Back Button
            BackButton(action: onBack, style: .onTeal)
                .padding(.top, 64)

            // Text Block
            VStack(alignment: .leading, spacing: 8) {
                if let title = title {
                    Text(title)
                        .font(Font.AppFont.plusJakartaSansBold28)
                        .foregroundColor(Color.SettingsSemantic.headerTitle)
                }

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(Font.AppFont.lexendDecaMedium16)
                        .foregroundColor(Color.SettingsSemantic.headerSubtitle)
                }
            }
            .padding(.bottom, 28)
        }
        .padding(.horizontal, 24)
        .navigationBarHidden(true)
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
    VStack(spacing: 20) {
        // Default usage (Settings main screen)
        SettingsHeaderSection(onBack: {})
        
        // Custom usage (Help screen)
        SettingsHeaderSection(title: "Help", subtitle: nil, onBack: {})
    }
    .background(Color.SettingsSemantic.screenBackground)
}
