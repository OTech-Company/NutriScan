import Foundation

final class ScanRepositoryImpl: ScanRepository {

    private let apiService: ScanAPIServicing

    init(apiService: ScanAPIServicing = ScanAPIService()) {
        self.apiService = apiService
    }

    func fetchScans(page: Int, size: Int) async throws -> ScanPage {
        let dto = try await apiService.fetchScans(page: page, size: size)
        return mapPage(dto)
    }

    func submitScan(imageData: Data) async throws -> ScanSubmission {
        let dto = try await apiService.submitScan(imageData: imageData)
        return ScanSubmission(
            scanId: dto.scanId,
            status: ScanStatus(rawValue: dto.status) ?? .processing
        )
    }

    func fetchScanDetail(scanId: String) async throws -> ScanDetail {
        let dto = try await apiService.fetchScanDetail(scanId: scanId)
        return mapDetail(dto)
    }

    // MARK: - Mapping

    private func mapPage(_ dto: ScanPageDTO) -> ScanPage {
        ScanPage(
            totalElements: dto.totalElements,
            totalPages: dto.totalPages,
            page: dto.pageable.pageNumber,
            size: dto.size,
            numberOfElements: dto.numberOfElements,
            first: dto.first,
            last: dto.last,
            content: dto.content.map(mapListItem)
        )
    }

    private func mapListItem(_ dto: ScanListItemDTO) -> ScanListItem {
        ScanListItem(
            id: dto.scanId,
            scanId: dto.scanId,
            imageUrl: dto.imageUrl,
            verdict: ScanResultVerdict(rawValue: dto.verdict ?? "UNKNOWN") ?? .unknown,
            scannedAt: ISO8601DateFormatter().date(from: dto.scannedAt ?? "") ?? Date()
        )
    }

    private func mapDetail(_ dto: ScanDetailDTO) -> ScanDetail {
        ScanDetail(
            id: dto.scanId,
            scanId: dto.scanId,
            status: ScanStatus(rawValue: dto.status) ?? .processing,
            scannedAt: dto.scannedAt.flatMap { ISO8601DateFormatter().date(from: $0) },
            imageUrl: dto.imageUrl,
            productName: dto.productName,
            foodSafetyResponse: dto.foodSafetyResponse.map(mapSafety),
            nutritionFacts: dto.nutritionFacts.map(mapNutrition)
        )
    }

    private func mapSafety(_ dto: FoodSafetyResponseDTO) -> ScanFoodSafetyResponse {
        ScanFoodSafetyResponse(
            verdict: ScanResultVerdict(rawValue: dto.verdict ?? "UNKNOWN") ?? .unknown,
            flaggedIngredients: dto.flaggedIngredients?.map(mapIngredient) ?? [],
            summary: dto.summary ?? ""
        )
    }

    private func mapIngredient(_ dto: ScanFlaggedIngredientDTO) -> ScanFlaggedIngredient {
        ScanFlaggedIngredient(
            ingredient: dto.ingredient ?? "",
            reason: dto.reason ?? "",
            type: ScanFlagType(rawValue: dto.type ?? "OTHER") ?? .other,
            name: dto.name ?? []
        )
    }

    private func mapNutrition(_ dto: ScanNutritionFactsDTO) -> ScanNutritionFacts {
        ScanNutritionFacts(
            calories: dto.calories ?? 0,
            proteinGrams: dto.proteinGrams ?? 0,
            carbsGrams: dto.carbsGrams ?? 0,
            fatG: dto.fatG ?? 0,
            fiberGrams: dto.fiberGrams ?? 0,
            sugarG: dto.sugarG ?? 0,
            sodiumMg: dto.sodiumMg ?? 0
        )
    }
}
