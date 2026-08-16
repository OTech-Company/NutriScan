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
            LocalizationKeys.Calories.totalMeals.localized

        case .water:
            LocalizationKeys.Calories.water.localized

        case .steps:
            LocalizationKeys.StepTracker.steps.localized

        case .exercise:
            LocalizationKeys.Exercise.title.localized
        }
    }

    var primaryUnit: String {
        switch self {
        case .totalMeals:
            LocalizationKeys.Favorites.kcal.localized

        case .water:
            LocalizationKeys.Calories.cups.localized

        case .steps:
            LocalizationKeys.StepTracker.steps.localized

        case .exercise:
            LocalizationKeys.StepTracker.min.localized
        }
    }

    var secondaryUnit: String? {
        switch self {
        case .totalMeals:
            nil

        case .water:
            LocalizationKeys.Calories.target.localized

        case .steps, .exercise:
            LocalizationKeys.Favorites.kcal.localized
        }
    }

    var accessibilityTitle: String {
        title.replacingOccurrences(of: "\n", with: " ")
    }
}
