//
//  HomeDailyTipSection.swift
//  NutriScan
//

import SwiftUI

struct HomeDailyTipSection: View {
    let tipMessage: String

    var body: some View {
        HStack(spacing: 12) {

            Circle()
                .fill(Color.HomeSemantic.tipIconBackground)
                .frame(width: 40, height: 40)
                .overlay(
                    Image("daily_health_tip")
                        .font(.system(size: 18))
                        .foregroundColor(Color.HomeSemantic.tipIcon)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("Daily Health Tip")
                    .font(Font.AppFont.textPrimary)
                    .foregroundColor(Color.HomeSemantic.tipLabel)

                Text(tipMessage)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.HomeSemantic.tipMessage)
                    .lineLimit(3)
            }

            Spacer()
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.HomeSemantic.tipBackgroundStart, Color.HomeSemantic.tipBackgroundEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.HomeSemantic.tipBorder, lineWidth: 1)
        )
        .customLightShadow()
    }
}

#Preview("Light") {
    HomeDailyTipSection(tipMessage: "Stay hydrated! Drink at least 8 glasses of water today.")
        .padding(20)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    HomeDailyTipSection(tipMessage: "Stay hydrated! Drink at least 8 glasses of water today.")
        .padding(20)
        .preferredColorScheme(.dark)
}
