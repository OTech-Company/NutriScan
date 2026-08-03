//
//  DayUIState.swift
//  NutriScan
//
//  Created by albaraa alsayed on 19/02/1448 AH.
//

import Foundation

struct DayUIState: Identifiable, Equatable {
    let id: String
    let date: String
    let cards: [DayStatusCardUIState]
}

extension DayUIState {
    init(day: CaloriesHistoryDay) {
        id = String(day.id)
        date = day.date.formatted(
            .dateTime
                .day()
                .month(.twoDigits)
                .year()
        )
        cards = [
            DayStatusCardUIState(
                type: .totalMeals,
                primaryValue: day.totalMealCalories.formatted()
            ),
            DayStatusCardUIState(
                type: .water,
                primaryValue: day.waterCount.formatted(),
                secondaryValue: day.targetWaterCount.formatted()
            ),
            DayStatusCardUIState(
                type: .steps,
                primaryValue: day.stepCount.formatted(),
                secondaryValue: Self.format(day.stepCalories)
            ),
            DayStatusCardUIState(
                type: .exercise,
                primaryValue: Self.format(day.exerciseMinutes),
                secondaryValue: Self.format(day.exerciseCalories)
            )
        ]
    }

    private static func format(_ value: Double) -> String {
        value.formatted(
            .number.precision(.fractionLength(value.rounded() == value ? 0 : 1))
        )
    }
}
