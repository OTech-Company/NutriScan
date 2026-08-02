//
//  DayUIState.swift
//  NutriScan
//
//  Created by albaraa alsayed on 19/02/1448 AH.
//

import Foundation

struct DayUIState: Identifiable {
    let id: String
    let date: String
    let cards: [DayStatusCardUIState]
}

extension DayUIState {
    static let caloriesHistoryPreview: [DayUIState] = (0..<4).map { index in
        DayUIState(
            id: "2026-07-23-\(index)",
            date: "23-7-2026",
            cards: [
                DayStatusCardUIState(
                    type: .totalMeals,
                    primaryValue: "2400"
                ),
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
                    secondaryValue: "2009"
                )
            ]
        )
    }
}
