import Foundation

struct ScanListItem: Identifiable, Equatable {
    let id: String
    let scanId: String
    let imageUrl: String?
    let verdict: Verdict
    let scannedAt: Date
}

struct ScanDetail: Identifiable, Equatable {
    let id: String
    let scanId: String
    let status: ScanStatus
    let scannedAt: Date?
    let imageUrl: String?
    let foodSafetyResponse: FoodSafetyResponse?
    let nutritionFacts: NutritionFacts?
}

struct FoodSafetyResponse: Equatable {
    let verdict: Verdict
    let flaggedIngredients: [FlaggedIngredient]
    let summary: String
}

struct FlaggedIngredient: Equatable {
    let ingredient: String
    let reason: String
    let type: FlagType
    let name: [String]
}

struct NutritionFacts: Equatable {
    let calories: Int
    let proteinGrams: Double
    let carbsGrams: Double
    let fatG: Double
    let fiberGrams: Double
    let sugarG: Double
    let sodiumMg: Double
}

struct ScanPage: Equatable {
    let totalElements: Int
    let totalPages: Int
    let page: Int
    let size: Int
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let content: [ScanListItem]
}

struct ScanSubmission: Equatable {
    let scanId: String
    let status: ScanStatus
}

enum Verdict: String, Decodable, Equatable {
    case safe = "SAFE"
    case unsafe = "UNSAFE"
    case caution = "CAUTION"
    case unknown = "UNKNOWN"
}

enum ScanStatus: String, Decodable, Equatable {
    case processing = "PROCESSING"
    case completed = "COMPLETED"
    case failed = "FAILED"
}

enum FlagType: String, Decodable, Equatable {
    case allergy = "ALLERGY"
    case additive = "ADDITIVE"
    case dietary = "DIETARY"
    case other = "OTHER"
}
