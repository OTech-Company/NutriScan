struct ScanDetailDTO: Decodable {
    let scanId: String
    let status: String
    let scannedAt: String?
    let imageUrl: String?
    let productName: String?
    let verdict: String?
    let summary: String?
    let flaggedIngredients: [ScanFlaggedIngredientDTO]?
    let nutritionFacts: ScanNutritionFactsDTO?
}
