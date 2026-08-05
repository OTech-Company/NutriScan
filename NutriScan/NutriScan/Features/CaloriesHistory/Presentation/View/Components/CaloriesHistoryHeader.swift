//
//  CaloriesHistoryHeader.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import SwiftUI

struct CaloriesHistoryHeader: View {
    let onBackTap: () -> Void
    let onCalendarTap: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            BackButton(action: onBackTap)

            Text("Calories History")
                .font(Font.AppFont.subtitle1)
                .foregroundStyle(Color.CaloriesHistorySemantic.title)
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Spacer(minLength: 8)

            Button(action: onCalendarTap) {
                Image(systemName: "calendar")
                    .font(.system(size: 21, weight: .regular))
                    .foregroundStyle(Color.Teal.teal1000)
                    .frame(width: 48, height: 48)
                    .background(Color.CaloriesHistorySemantic.calendarButtonBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Choose history date")
        }
        .padding(.top, 16)
    }
}

#Preview("Header Light") {
    CaloriesHistoryHeader(onBackTap: {}, onCalendarTap: {})
        .padding(.horizontal, 22)
        .padding(.bottom, 16)
        .background(Color.CaloriesHistorySemantic.background)
        .preferredColorScheme(.light)
}

#Preview("Header Dark") {
    CaloriesHistoryHeader(onBackTap: {}, onCalendarTap: {})
        .padding(.horizontal, 22)
        .padding(.bottom, 16)
        .background(Color.CaloriesHistorySemantic.background)
        .preferredColorScheme(.dark)
}
