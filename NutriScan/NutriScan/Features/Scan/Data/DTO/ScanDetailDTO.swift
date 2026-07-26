struct ScanDetailDTO: Decodable {
    let scanId: String
    let status: String
    let scannedAt: String?
    let imageUrl: String?
    let foodSafetyResponse: FoodSafetyResponseDTO?
    let nutritionFacts: ScanNutritionFactsDTO?
    let productName: String?
}
