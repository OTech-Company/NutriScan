//
//  MealDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct MealDTO: Codable {
    let scanId: String
    let productName: String
    let imageUrl: String
    let mealCnt: Int
    let nutritionFacts: MealNutritionFactsDTO
}

extension MealDTO {
    init(from meal: Meal) {
        self.scanId = meal.scanId
        self.productName = meal.productName
        self.imageUrl = meal.imageUrl
        self.mealCnt = meal.mealCnt
        self.nutritionFacts = MealNutritionFactsDTO(from: meal.nutritionFacts)
    }
}
