import Foundation

struct ScanResultDTO: Decodable {
    let scanId: String
    let status: String
    let scannedAt: Date?
    let imageUrl: String?
    let foodSafetyResponse: FoodSafetyResponseDTO?
    let nutritionFacts: NutritionFactsDTO?
}

struct FoodSafetyResponseDTO: Decodable {
    let verdict: ScanVerdict
    let flaggedIngredients: [FlaggedIngredientDTO]?
    let summary: String?
}

struct FlaggedIngredientDTO: Decodable {
    let ingredient: String
    let reason: String
    let type: FlaggedIngredient.FlagType
}

struct NutritionFactsDTO: Decodable {
    let calories: Int
    let proteinGrams: Double
    let carbsGrams: Double
    let fatG: Double
    let fiberGrams: Double
    let sugarG: Double
    let sodiumMg: Double
}
