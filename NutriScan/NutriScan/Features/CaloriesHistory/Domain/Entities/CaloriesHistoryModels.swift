//
//  CaloriesHistoryModels.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import Foundation

struct CaloriesHistoryPage: Equatable, Sendable {
    let days: [CaloriesHistoryDay]
    let totalElements: Int
    let totalPages: Int
    let currentPage: Int
    let pageSize: Int
    let numberOfElements: Int
    let isFirst: Bool
    let isLast: Bool
}

struct CaloriesHistoryDay: Identifiable, Equatable, Sendable {
    let id: Int
    let date: Date
    let targetWaterCount: Int
    let waterCount: Int
    let stepCount: Int
    let stepCalories: Double
    let exerciseCalories: Double
    let exerciseMinutes: Double
    let totalMealCalories: Int
    let mealCount: Int
    let meals: [CaloriesHistoryMeal]
}

struct CaloriesHistoryMeal: Identifiable, Equatable, Sendable {
    var id: String { scanID }

    let scanID: String
    let productName: String
    let imageURL: String
    let count: Int
    let nutritionFacts: CaloriesHistoryNutritionFacts
}

struct CaloriesHistoryNutritionFacts: Equatable, Sendable {
    let calories: Int
    let proteinGrams: Double
    let carbsGrams: Double
    let fatGrams: Double
    let fiberGrams: Double
    let sugarGrams: Double
    let sodiumMilligrams: Double
}

enum CaloriesHistoryError: Error, Equatable, LocalizedError {
    case invalidIdentity
    case invalidDate
    case notFound

    var errorDescription: String? {
        switch self {
        case .invalidIdentity, .invalidDate:
            return LocalizationKeys.Calories.historyIncompleteResponse.localized
        case .notFound:
            return LocalizationKeys.Calories.historyNotFound.localized
        }
    }
}
