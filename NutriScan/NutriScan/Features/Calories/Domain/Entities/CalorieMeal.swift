//
//  CalorieMeal.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct CalorieMeal {
    let scanId: String
    let productName: String
    let imageUrl: String
    let mealCnt: Int
    let nutritionFacts: MealNutritionFacts
}

extension CalorieMeal {
    init(from dto: CalorieMealsDTO) {
        self.scanId = dto.scanId ?? ""
        self.productName = dto.productName ?? ""
        self.imageUrl = dto.imageUrl ?? ""
        self.mealCnt = dto.mealCnt ?? 0
        self.nutritionFacts = MealNutritionFacts(from: dto.nutritionFacts)
    }
}
