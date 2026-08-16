//
//  NotificationHistoryHeader.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import SwiftUI

struct NotificationHistoryHeader: View {
    let title: String = LocalizationKeys.Profile.notifications.localized
    var onBack: () -> Void
    var onClearAll: () -> Void
    var onSettingsTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Action Bar (Back button on Left, Clear All + Settings on Right)
            HStack(alignment: .center) {
                BackButton(action: onBack, style: .onTeal)

                Spacer()

                HStack(spacing: 16) {
                    Button(action: onClearAll) {
                        Text(LocalizationKeys.Notifications.clearAll.localized)
                            .font(Font.AppFont.textSecondary)
                            .foregroundColor(Color.NotificationHistorySemantic.clearAllButton)
                    }

                    Button(action: onSettingsTap) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.top, 60)

            // Title Block
            Text(title)
                .font(Font.AppFont.plusJakartaSansBold28)
                .foregroundColor(Color.NotificationHistorySemantic.headerTitleText)
                .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.NotificationHistorySemantic.headerBackground)
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
    NotificationHistoryHeader(
        onBack: {},
        onClearAll: {},
        onSettingsTap: {}
    )
    .background(Color.NotificationHistorySemantic.screenBackground)
}
