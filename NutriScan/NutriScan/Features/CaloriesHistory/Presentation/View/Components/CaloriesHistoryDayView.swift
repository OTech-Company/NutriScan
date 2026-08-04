//
//  CaloriesHistoryDayView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import SwiftUI

struct CaloriesHistoryDayView: View {
    let day: DayUIState

    var body: some View {
        ZStack(alignment: .top) {
            HStack(spacing: 6) {
                ForEach(day.cards) { card in
                    CaloriesHistoryMetricCard(state: card)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 20)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity)
            .frame(height: 105)
            .background(Color.CaloriesHistorySemantic.dayBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .offset(y: 14)

            Text(day.date)
                .font(Font.AppFont.textSecondary)
                .foregroundStyle(Color.CaloriesHistorySemantic.dateText)
                .padding(.horizontal, 14)
                .padding(.vertical, 4)
                .background(Color.CaloriesHistorySemantic.dateBackground)
                .clipShape(Capsule())
                .customLightShadow()
        }
        .frame(height: 121)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("History for \(day.date)")
    }
}

#Preview("Day Row Light") {
    CaloriesHistoryDayView(day: caloriesHistoryDayViewPreviewState)
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .background(Color.CaloriesHistorySemantic.background)
        .preferredColorScheme(.light)
}

#Preview("Day Row Dark") {
    CaloriesHistoryDayView(day: caloriesHistoryDayViewPreviewState)
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .background(Color.CaloriesHistorySemantic.background)
        .preferredColorScheme(.dark)
}

private let caloriesHistoryDayViewPreviewState = DayUIState(
    id: "preview-day",
    date: "03-08-2026",
    cards: [
        DayStatusCardUIState(type: .totalMeals, primaryValue: "2400"),
        DayStatusCardUIState(
            type: .water,
            primaryValue: "7",
            secondaryValue: "8"
        ),
        DayStatusCardUIState(
            type: .steps,
            primaryValue: "10000",
            secondaryValue: "415"
        ),
        DayStatusCardUIState(
            type: .exercise,
            primaryValue: "46",
            secondaryValue: "260"
        )
    ]
)
