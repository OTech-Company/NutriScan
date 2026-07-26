import Foundation

@MainActor
final class ProductDetailsViewModel: ObservableObject {

    @Published private(set) var uiState: ProductDetailsUIState?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let scanId: String?
    private let fetchScanDetailUseCase: FetchScanDetailUseCase?

    init(scanId: String, fetchScanDetailUseCase: FetchScanDetailUseCase = DIContainer.shared.resolve(type: FetchScanDetailUseCase.self)) {
        self.scanId = scanId
        self.fetchScanDetailUseCase = fetchScanDetailUseCase
    }

    init(detail: ScanDetail) {
        self.scanId = nil
        self.fetchScanDetailUseCase = nil
        self.uiState = detail.toUIState()
    }

    func loadIfNeeded() {
        guard uiState == nil, let scanId, let useCase = fetchScanDetailUseCase else { return }
        isLoading = true
        Task {
            do {
                let detail = try await useCase.execute(scanId: scanId)
                self.uiState = detail.toUIState()
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

// MARK: - ScanDetail → ProductDetailsUIState Mapping

private extension ScanDetail {

    func toUIState() -> ProductDetailsUIState {
        let safety = foodSafetyResponse

        let safetyLevel: SafetyLevel = {
            guard let verdict = safety?.verdict else { return .caution }
            switch verdict {
            case .safe: return .safe
            case .unsafe: return .unsafe
            case .caution, .unknown: return .caution
            }
        }()

        let headerState = ProductHeaderUIState(
            imageUrl: imageUrl ?? "",
            productName: productName ?? "Scanned Product",
            scannedAt: scannedAt.map { ISO8601DateFormatter().string(from: $0) } ?? ""
        )

        let safetyState = ProductSafetyUIState(
            safetyLevel: safetyLevel,
            safetyDescription: safety?.summary ?? "No safety data available."
        )

        let ingredientsState = ProductIngredientsUIState(
            safetyLevel: safetyLevel,
            unsafeIngredients: (safety?.flaggedIngredients ?? []).map { ingredient in
                UnsafeIngredientUIState(
                    name: ingredient.ingredient,
                    allergyMatch: ingredient.type.rawValue,
                    description: ingredient.reason
                )
            }
        )

        let nutritionState = ProductNutritionUIState(
            nutritionFacts: buildNutritionFacts(from: nutritionFacts)
        )

        return ProductDetailsUIState(
            headerState: headerState,
            safetyState: safetyState,
            ingredientsState: ingredientsState,
            nutritionState: nutritionState
        )
    }

    private func buildNutritionFacts(from facts: ScanNutritionFacts?) -> [NutritionFactUIState] {
        guard let facts else { return [] }
        return [
            NutritionFactUIState(title: "Calories", value: "\(facts.calories) kcal"),
            NutritionFactUIState(title: "Protein", value: String(format: "%.1fg", facts.proteinGrams)),
            NutritionFactUIState(title: "Carbs", value: String(format: "%.1fg", facts.carbsGrams)),
            NutritionFactUIState(title: "Fat", value: String(format: "%.1fg", facts.fatG)),
            NutritionFactUIState(title: "Fiber", value: String(format: "%.1fg", facts.fiberGrams)),
            NutritionFactUIState(title: "Sugar", value: String(format: "%.1fg", facts.sugarG)),
            NutritionFactUIState(title: "Sodium", value: String(format: "%.0fmg", facts.sodiumMg))
        ]
    }
}
