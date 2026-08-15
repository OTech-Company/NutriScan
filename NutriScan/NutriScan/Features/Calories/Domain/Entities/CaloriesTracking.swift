//
//  CaloriesTracking.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct CaloriesTracking {
    let id: Int
    let date: String
    let targetWaterCnt: Int
    let waterCnt: Int
    let stepsCnt: Int
    let stepsKcal: Double
    let exerciseKcal: Double
    let exerciseMin: Double
    let totalMealKcal: Int
    let meals: [CalorieMeal]

    init(
        id: Int,
        date: String,
        targetWaterCnt: Int,
        waterCnt: Int,
        stepsCnt: Int,
        stepsKcal: Double = 0,
        exerciseKcal: Double = 0,
        exerciseMin: Double = 0,
        totalMealKcal: Int = 0,
        meals: [CalorieMeal]
    ) {
        self.id = id
        self.date = date
        self.targetWaterCnt = targetWaterCnt
        self.waterCnt = waterCnt
        self.stepsCnt = stepsCnt
        self.stepsKcal = stepsKcal
        self.exerciseKcal = exerciseKcal
        self.exerciseMin = exerciseMin
        self.totalMealKcal = totalMealKcal
        self.meals = meals
    }
}

extension CaloriesTracking {
    var calculatedMealCalories: Int {
        meals.reduce(0) { $0 + $1.nutritionFacts.calories * $1.mealCnt }
    }

    var mealCalories: Int {
        calculatedMealCalories
    }

    var totalCalories: Int {
        calculatedMealCalories
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
        dateString(from: Date())
    }

    static func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = Calendar.current.timeZone
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    static func date(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = Calendar.current.timeZone
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
}

extension CaloriesTracking {
    init(from dto: CaloriesTrackingDTO) {
        self.id = dto.id ?? 0
        self.date = dto.date ?? Self.todayString
        self.targetWaterCnt = dto.targetWaterCnt ?? 0
        self.waterCnt = dto.waterCnt ?? 0
        self.stepsCnt = dto.stepsCnt ?? 0
        self.stepsKcal = dto.stepsKcal ?? 0
        self.exerciseKcal = dto.exerciseKcal ?? 0
        self.exerciseMin = dto.exerciseMin ?? 0
        self.totalMealKcal = dto.totalMealKcal ?? 0
        self.meals = (dto.meals ?? []).map { CalorieMeal(from: $0) }
    }
}
