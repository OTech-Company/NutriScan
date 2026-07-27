//
//  Meal.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct Meal {
    let scanId: String
    let productName: String
    let imageUrl: String
    let mealCnt: Int
    let nutritionFacts: MealNutritionFacts
}

extension Meal {
    init(from dto: MealDTO) {
        self.scanId = dto.scanId
        self.productName = dto.productName
        self.imageUrl = dto.imageUrl
        self.mealCnt = dto.mealCnt
        self.nutritionFacts = MealNutritionFacts(from: dto.nutritionFacts)
    }
}
