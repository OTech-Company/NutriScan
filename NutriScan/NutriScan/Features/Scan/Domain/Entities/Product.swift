import Foundation

struct ScanListItem: Identifiable, Hashable {
    let id: String
    let scanId: String
    let imageUrl: String?
    let verdict: ScanResultVerdict
    let scannedAt: Date
}

struct ScanDetail: Identifiable, Hashable {
    let id: String
    let scanId: String
    let status: ScanStatus
    let scannedAt: Date?
    let imageUrl: String?
    let productName: String?
    let foodSafetyResponse: ScanFoodSafetyResponse?
    let nutritionFacts: ScanNutritionFacts?
}

struct ScanFoodSafetyResponse: Hashable {
    let verdict: ScanResultVerdict
    let flaggedIngredients: [ScanFlaggedIngredient]
    let summary: String
}

struct ScanFlaggedIngredient: Hashable {
    let ingredient: String
    let reason: String
    let type: ScanFlagType
    let name: [String]
}

struct ScanNutritionFacts: Hashable {
    let calories: Int
    let proteinGrams: Double
    let carbsGrams: Double
    let fatG: Double
    let fiberGrams: Double
    let sugarG: Double
    let sodiumMg: Double
}

struct ScanPage: Hashable {
    let totalElements: Int
    let totalPages: Int
    let page: Int
    let size: Int
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let content: [ScanListItem]
}

struct ScanSubmission: Hashable {
    let scanId: String
    let status: ScanStatus
}

enum ScanResultVerdict: String, Decodable, Hashable {
    case safe = "SAFE"
    case unsafe = "UNSAFE"
    case caution = "CAUTION"
    case unknown = "UNKNOWN"
}

enum ScanFlagType: String, Decodable, Hashable {
    case allergy = "ALLERGY"
    case additive = "ADDITIVE"
    case dietary = "DIETARY"
    case other = "OTHER"
}