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

#Preview {
    CaloriesHistoryDayView(day: DayUIState(id: "34", date: "24-09-2029", cards: [
        DayStatusCardUIState(type: .totalMeals, primaryValue: "2200"),
        DayStatusCardUIState(type: .water, primaryValue: "7", secondaryValue: "8"),
        DayStatusCardUIState(type: .steps, primaryValue: "2200", secondaryValue: "220"),
        DayStatusCardUIState(type: .exercise, primaryValue: "2200", secondaryValue: "220"),
    ])
    )
}
