//
//  DailyTrackingMealDTO.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 30/07/2026.
//

import Foundation

/// Response DTO shared by both POST and PUT daily-tracking/meals endpoints.
struct DailyTrackingMealDTO: Codable {
    let scanId: String?
    let productName: String?
    let imageUrl: String?
    let mealCnt: Int?
    let nutritionFacts: NutritionFactsDTO?
}

struct NutritionFactsDTO: Codable {
    let calories: Double?
    let proteinGrams: Double?
    let carbsGrams: Double?
    let fatG: Double?
    let fiberGrams: Double?
    let sugarG: Double?
    let sodiumMg: Double?
}
