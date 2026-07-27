//
//  MealNutritionFactsDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct MealNutritionFactsDTO: Codable {
    let calories: Int
    let proteinGrams: Double
    let carbsGrams: Double
    let fatG: Double
    let fiberGrams: Double
    let sugarG: Double
    let sodiumMg: Double
}

extension MealNutritionFactsDTO {
    init(from facts: MealNutritionFacts) {
        self.calories = facts.calories
        self.proteinGrams = facts.proteinGrams
        self.carbsGrams = facts.carbsGrams
        self.fatG = facts.fatG
        self.fiberGrams = facts.fiberGrams
        self.sugarG = facts.sugarG
        self.sodiumMg = facts.sodiumMg
    }
}
