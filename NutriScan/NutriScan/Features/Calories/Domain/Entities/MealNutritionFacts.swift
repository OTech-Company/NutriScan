//
//  MealNutritionFacts.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct MealNutritionFacts {
    let calories: Int
    let proteinGrams: Double
    let carbsGrams: Double
    let fatG: Double
    let fiberGrams: Double
    let sugarG: Double
    let sodiumMg: Double
}

extension MealNutritionFacts {
    init(from dto: MealNutritionFactsDTO?) {
        self.calories = dto?.calories ?? 0
        self.proteinGrams = dto?.proteinGrams ?? 0
        self.carbsGrams = dto?.carbsGrams ?? 0
        self.fatG = dto?.fatG ?? 0
        self.fiberGrams = dto?.fiberGrams ?? 0
        self.sugarG = dto?.sugarG ?? 0
        self.sodiumMg = dto?.sodiumMg ?? 0
    }
}
