import Foundation

enum ScanMapper {

    static func toDomain(_ dto: ScanResultDTO) -> ScanResult {
        ScanResult(
            scanId: dto.scanId,
            imageUrl: dto.imageUrl,
            verdict: dto.foodSafetyResponse?.verdict ?? .safe,
            scannedAt: dto.scannedAt,
            summary: dto.foodSafetyResponse?.summary,
            flaggedIngredients: dto.foodSafetyResponse?.flaggedIngredients?.map(toDomain) ?? [],
            nutritionFacts: dto.nutritionFacts.map(toDomain)
        )
    }

    static func toDomain(_ dto: FlaggedIngredientDTO) -> FlaggedIngredient {
        FlaggedIngredient(
            ingredient: dto.ingredient,
            reason: dto.reason,
            type: dto.type
        )
    }

    static func toDomain(_ dto: NutritionFactsDTO) -> NutritionFacts {
        NutritionFacts(
            calories: dto.calories,
            proteinGrams: dto.proteinGrams,
            carbsGrams: dto.carbsGrams,
            fatGrams: dto.fatG,
            fiberGrams: dto.fiberGrams,
            sugarGrams: dto.sugarG,
            sodiumMg: dto.sodiumMg
        )
    }
}
