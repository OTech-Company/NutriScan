import Foundation

struct ScanResult: Identifiable, Equatable {
    let scanId: String
    let imageUrl: String?
    let verdict: ScanVerdict
    let scannedAt: Date?
    let summary: String?
    let flaggedIngredients: [FlaggedIngredient]
    let nutritionFacts: NutritionFacts?

    var id: String { scanId }
}
