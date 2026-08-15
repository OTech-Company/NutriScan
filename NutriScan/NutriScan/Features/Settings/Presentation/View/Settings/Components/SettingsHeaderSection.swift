//
//  SettingsHeaderSection.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import SwiftUI

// MARK: - Settings Header Section
struct SettingsHeaderSection: View {
    var title: String? = nil
    var subtitle: String? = nil
    var onBack: () -> Void

    var body: some View {
        let displayTitle = title ?? LocalizationKeys.Settings.title.localized
        let displaySubtitle = subtitle ?? LocalizationKeys.Settings.subtitle.localized

        VStack(alignment: .leading, spacing: 24) {
            // Back Button
            BackButton(action: onBack, style: .onTeal)
                .padding(.top, 64)

            // Text Block
            VStack(alignment: .leading, spacing: 8) {
                Text(displayTitle)
                    .font(Font.AppFont.plusJakartaSansBold28)
                    .foregroundColor(Color.SettingsSemantic.headerTitle)

                if title == nil || subtitle != nil {
                    Text(displaySubtitle)
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
