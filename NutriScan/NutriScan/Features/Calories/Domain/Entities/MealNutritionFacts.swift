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
    init(from dto: MealNutritionFactsDTO) {
        self.calories = dto.calories
        self.proteinGrams = dto.proteinGrams
        self.carbsGrams = dto.carbsGrams
        self.fatG = dto.fatG
        self.fiberGrams = dto.fiberGrams
        self.sugarG = dto.sugarG
        self.sodiumMg = dto.sodiumMg
    }
}
