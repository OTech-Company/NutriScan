import Foundation

struct FoodSafetyResponseDTO: Decodable {
    let verdict: String?
    let flaggedIngredients: [ScanFlaggedIngredientDTO]?
    let summary: String?
    let familyAlerts: [ScanFamilyAlertDTO]?
}

struct ScanFamilyAlertDTO: Decodable {
    let targetProfile: String?
    let severity: String?
    let reason: String?
}

// MARK: - Domain Mappings

extension FoodSafetyResponseDTO {
    func toDomain() -> ScanFoodSafetyResponse {
        ScanFoodSafetyResponse(
            verdict: ScanResultVerdict(rawValue: self.verdict?.uppercased() ?? "") ?? .unknown,
            flaggedIngredients: self.flaggedIngredients?.compactMap { $0.toDomain() } ?? [],
            summary: self.summary ?? "",
            familyAlerts: self.familyAlerts?.compactMap { $0.toDomain() } ?? []
        )
    }
}

extension ScanFamilyAlertDTO {
    func toDomain() -> ScanFamilyAlert {
        ScanFamilyAlert(
            targetProfile: self.targetProfile ?? "Family",
            severity: self.severity ?? "CAUTION",
            reason: self.reason ?? ""
        )
    }
}

extension ScanFlaggedIngredientDTO {
    func toDomain() -> ScanFlaggedIngredient {
        ScanFlaggedIngredient(
            ingredient: self.ingredient ?? "",
            reason: self.reason ?? "",
            type: ScanFlagType(rawValue: self.type?.uppercased() ?? "") ?? .other,
            name: self.name ?? []
        )
    }
}
