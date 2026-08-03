//
//  CaloriesHistoryDTOs.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import Foundation

struct CaloriesHistoryPageDTO: Decodable {
    let totalElements: Int?
    let totalPages: Int?
    let pageable: CaloriesHistoryPageableDTO?
    let first: Bool?
    let last: Bool?
    let numberOfElements: Int?
    let size: Int?
    let content: [CaloriesHistorySummaryDTO]?
    let number: Int?
    let sort: CaloriesHistorySortDTO?
    let empty: Bool?
}

struct CaloriesHistoryPageableDTO: Decodable {
    let pageNumber: Int?
    let paged: Bool?
    let pageSize: Int?
    let unpaged: Bool?
    let offset: Int?
    let sort: CaloriesHistorySortDTO?
}

struct CaloriesHistorySortDTO: Decodable {
    let sorted: Bool?
    let unsorted: Bool?
    let empty: Bool?
}

struct CaloriesHistorySummaryDTO: Decodable {
    let id: Int?
    let date: String?
    let targetWaterCnt: Int?
    let waterCnt: Int?
    let stepsCnt: Int?
    let stepsKcal: Double?
    let exerciseKcal: Double?
    let exerciseMin: Double?
    let totalMealKcal: Int?
    let mealCount: Int?
}

struct CaloriesHistoryDetailDTO: Decodable {
    let id: Int?
    let date: String?
    let targetWaterCnt: Int?
    let waterCnt: Int?
    let stepsCnt: Int?
    let stepsKcal: Double?
    let exerciseKcal: Double?
    let exerciseMin: Double?
    let totalMealKcal: Int?
    let meals: [CaloriesHistoryMealDTO]?
}

struct CaloriesHistoryMealDTO: Decodable {
    let scanId: String?
    let productName: String?
    let imageUrl: String?
    let mealCnt: Int?
    let nutritionFacts: CaloriesHistoryNutritionFactsDTO?
}

struct CaloriesHistoryNutritionFactsDTO: Decodable {
    let calories: Int?
    let proteinGrams: Double?
    let carbsGrams: Double?
    let fatG: Double?
    let fiberGrams: Double?
    let sugarG: Double?
    let sodiumMg: Double?
}
