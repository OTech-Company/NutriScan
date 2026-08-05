//
//  DayStatusCard.swift
//  NutriScan
//
//  Created by albaraa alsayed on 19/02/1448 AH.
//

import Foundation

enum DayStatusCard: CaseIterable, Hashable {
    case totalMeals
    case water
    case steps
    case exercise

    var icon: String {
        switch self {
        case .totalMeals:
            "totalmealkcal"

        case .water:
            "water"

        case .steps:
            "stepsCounter"

        case .exercise:
            "exerciseDetails"
        }
    }

    var title: String {
        switch self {
        case .totalMeals:
            "Total\nMeals"

        case .water:
            "Water"

        case .steps:
            "Steps"

        case .exercise:
            "Exercise"
        }
    }

    var primaryUnit: String {
        switch self {
        case .totalMeals:
            "kcal"

        case .water:
            "cups"

        case .steps:
            "steps"

        case .exercise:
            "min"
        }
    }

    var secondaryUnit: String? {
        switch self {
        case .totalMeals:
            nil

        case .water:
            "target"

        case .steps, .exercise:
            "kcal"
        }
    }

    var accessibilityTitle: String {
        title.replacingOccurrences(of: "\n", with: " ")
    }
}
