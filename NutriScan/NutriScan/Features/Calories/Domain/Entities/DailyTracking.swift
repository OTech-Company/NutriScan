//
//  DailyTracking.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct DailyTracking {
    let id: Int
    let date: String
    let targetWaterCnt: Int
    let waterCnt: Int
    let stepsCnt: Int
    let meals: [Meal]
}

extension DailyTracking {
    var totalCalories: Int {
        meals.reduce(0) { $0 + $1.nutritionFacts.calories * $1.mealCnt }
    }

    var totalProteinGrams: Double {
        meals.reduce(0) { $0 + $1.nutritionFacts.proteinGrams * Double($1.mealCnt) }
    }

    var totalCarbsGrams: Double {
        meals.reduce(0) { $0 + $1.nutritionFacts.carbsGrams * Double($1.mealCnt) }
    }

    var totalFatGrams: Double {
        meals.reduce(0) { $0 + $1.nutritionFacts.fatG * Double($1.mealCnt) }
    }

    static var todayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

extension DailyTracking {
    init(from dto: DailyTrackingDTO) {
        self.id = dto.id
        self.date = dto.date
        self.targetWaterCnt = dto.targetWaterCnt
        self.waterCnt = dto.waterCnt
        self.stepsCnt = dto.stepsCnt
        self.meals = dto.meals.map { Meal(from: $0) }
    }
}
