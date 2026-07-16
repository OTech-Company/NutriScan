//
//  ScanResponse.swift
//  NutriScan
//
//  Created by Osama Hosam on 16/07/2026.
//

// GET /v1/scans/{scanId}
struct ScanResponse: Codable {
    let scanId: String
    let status: ScanStatus
    let scannedAt: String // ISO 8601 date string
    let imageUrl: String? // Nullable until cloud link is confirmed
    let verdict: ScanVerdict
    let summary: String
    let flaggedIngredients: [FlaggedIngredientDTO]
    let nutritionFacts: NutritionFactsDTO
}

enum ScanStatus: String, Codable {
    case processing = "PROCESSING"
    case completed = "COMPLETED"
    case failed = "FAILED"
}

enum ScanVerdict: String, Codable {
    case safe = "SAFE"
    case caution = "CAUTION"
    case unsafe = "UNSAFE"
}

struct FlaggedIngredientDTO: Codable {
    let type: FlagType
    let name: String
    let ingredient: String
    let reason: String
}

enum FlagType: String, Codable {
    case allergy = "ALLERGY"
    case chronicCondition = "CHRONIC_CONDITION"
}

struct NutritionFactsDTO: Codable {
    let servingSize: String
    let caloriesPerServing: Int
    let sugarG: Double
    let fatG: Double
    let saturatedFatG: Double
}
