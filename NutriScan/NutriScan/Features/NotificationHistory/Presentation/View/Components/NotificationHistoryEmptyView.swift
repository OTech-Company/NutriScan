//
//  NotificationHistoryEmptyView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import SwiftUI

struct NotificationHistoryEmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.Teal.teal1500)
                    .frame(width: 90, height: 90)

                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 38))
                    .foregroundColor(Color.Teal.teal300)
            }
            .padding(.top, 40)

            Text(LocalizationKeys.Notifications.emptyTitle.localized)
                .font(Font.AppFont.numbers)
                .foregroundColor(.white)

            Text(LocalizationKeys.Notifications.emptyDesc.localized)
                .font(Font.AppFont.textSecondary)
                .foregroundColor(Color.Teal.teal200.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview {
    NotificationHistoryEmptyView()
        .background(Color.NotificationHistorySemantic.screenBackground)
}
