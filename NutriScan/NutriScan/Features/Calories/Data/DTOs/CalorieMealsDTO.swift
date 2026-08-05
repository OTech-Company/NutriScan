//
//  CalorieMealsDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct CalorieMealsDTO: Codable {
    let scanId: String?
    let productName: String?
    let imageUrl: String?
    let mealCnt: Int?
    let nutritionFacts: MealNutritionFactsDTO?

    private enum CodingKeys: String, CodingKey {
        case scanId, productName, imageUrl, mealCnt, nutritionFacts
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scanId = try container.decodeIfPresent(String.self, forKey: .scanId)
        productName = try container.decodeIfPresent(String.self, forKey: .productName)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        mealCnt = try container.decodeIfPresent(Int.self, forKey: .mealCnt)
        nutritionFacts = try container.decodeIfPresent(MealNutritionFactsDTO.self, forKey: .nutritionFacts)
    }
}

struct AddMealRequestDTO: Encodable {
    let scanId: String
    let mealCnt: Int
}

struct UpdateMealCountRequestDTO: Encodable {
    let mealCnt: Int
}

extension CalorieMealsDTO {
    init(from meal: CalorieMeal) {
        self.scanId = meal.scanId
        self.productName = meal.productName
        self.imageUrl = meal.imageUrl
        self.mealCnt = meal.mealCnt
        self.nutritionFacts = MealNutritionFactsDTO(from: meal.nutritionFacts)
    }
}
