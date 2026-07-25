import Foundation

struct ScanListItem: Identifiable {
    let id: String
    let scanId: String
    let imageUrl: String?
    let verdict: ScanVerdict
    let scannedAt: Date
}

struct ScanDetail: Identifiable {
    let id: String
    let scanId: String
    let status: ScanStatus
    let scannedAt: Date?
    let imageUrl: String?
    let foodSafetyResponse: ScanFoodSafetyResponse?
    let nutritionFacts: ScanNutritionFacts?
}

struct ScanFoodSafetyResponse {
    let verdict: ScanVerdict
    let flaggedIngredients: [ScanFlaggedIngredient]
    let summary: String
}

struct ScanFlaggedIngredient {
    let ingredient: String
    let reason: String
    let type: ScanFlagType
    let name: [String]
}

struct ScanNutritionFacts {
    let calories: Int
    let proteinGrams: Double
    let carbsGrams: Double
    let fatG: Double
    let fiberGrams: Double
    let sugarG: Double
    let sodiumMg: Double
}

struct ScanPage {
    let totalElements: Int
    let totalPages: Int
    let page: Int
    let size: Int
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let content: [ScanListItem]
}

struct ScanSubmission {
    let scanId: String
    let status: ScanStatus
}

enum ScanVerdict: String, Decodable {
    case safe = "SAFE"
    case unsafe = "UNSAFE"
    case caution = "CAUTION"
    case unknown = "UNKNOWN"
}

enum ScanFlagType: String, Decodable {
    case allergy = "ALLERGY"
    case additive = "ADDITIVE"
    case dietary = "DIETARY"
    case other = "OTHER"
}
