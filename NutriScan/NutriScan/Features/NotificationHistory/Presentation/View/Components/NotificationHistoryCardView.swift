//
//  NotificationHistoryCardView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import SwiftUI

struct NotificationHistoryCardView: View {
    let item: NotificationHistoryItem
    var onTap: () -> Void = {}
    var onDelete: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 14) {
                // Icon Badge
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(Color.NotificationHistorySemantic.iconBadgeBackground)
                        .frame(width: 48, height: 48)
                        .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                        .overlay(
                            Image(systemName: item.category.icon)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color.NotificationHistorySemantic.iconTint)
                        )

                    if !item.isRead {
                        Circle()
                            .fill(Color.NotificationHistorySemantic.unreadDot)
                            .frame(width: 10, height: 10)
                            .offset(x: 2, y: -2)
                    }
                }

                // Content Stack
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(item.title)
                            .font(Font.AppFont.plusJakartaSansSemiBold16)
                            .foregroundColor(Color.NotificationHistorySemantic.cardTitleText)
                            .lineLimit(1)

                        Spacer(minLength: 8)

                        Text(item.relativeTimeString)
                            .font(Font.AppFont.lexendDecaRegular12)
                            .foregroundColor(Color.NotificationHistorySemantic.timeText)
                    }

                    Text(item.body)
                        .font(Font.AppFont.textSecondary)
                        .foregroundColor(Color.NotificationHistorySemantic.cardBodyText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
            .background(
                item.isRead
                ? Color.NotificationHistorySemantic.cardBackground
                : Color.NotificationHistorySemantic.unreadCardBackground
            )
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.NotificationHistorySemantic.cardBorder, lineWidth: item.isRead ? 1 : 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        NotificationHistoryCardView(
            item: NotificationHistoryItem(
                title: "Time for a break",
                body: "Stand up, stretch, drink some water, and rest your eyes for a ...",
                category: .breakTime,
                timestamp: Date().addingTimeInterval(-3600),
                isRead: false
            )
        )
        NotificationHistoryCardView(
            item: NotificationHistoryItem(
                title: "Stay hydrated",
                body: "You're at 0/8 glasses today.",
                category: .water,
                timestamp: Date().addingTimeInterval(-10800),
                isRead: true
            )
        )
    }
    .padding()
    .background(Color.NotificationHistorySemantic.screenBackground)
}
