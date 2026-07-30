//
//  MealNutritionFactsDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct MealNutritionFactsDTO: Codable {
    let calories: Int?
    let proteinGrams: Double?
    let carbsGrams: Double?
    let fatG: Double?
    let fiberGrams: Double?
    let sugarG: Double?
    let sodiumMg: Double?

    private enum CodingKeys: String, CodingKey {
        case calories, proteinGrams, carbsGrams, fatG, fiberGrams, sugarG, sodiumMg
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        calories = try container.decodeIfPresent(Int.self, forKey: .calories)
        proteinGrams = try container.decodeIfPresent(Double.self, forKey: .proteinGrams)
        carbsGrams = try container.decodeIfPresent(Double.self, forKey: .carbsGrams)
        fatG = try container.decodeIfPresent(Double.self, forKey: .fatG)
        fiberGrams = try container.decodeIfPresent(Double.self, forKey: .fiberGrams)
        sugarG = try container.decodeIfPresent(Double.self, forKey: .sugarG)
        sodiumMg = try container.decodeIfPresent(Double.self, forKey: .sodiumMg)
    }
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
