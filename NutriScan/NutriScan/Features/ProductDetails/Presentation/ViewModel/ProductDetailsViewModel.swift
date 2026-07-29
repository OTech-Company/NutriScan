import Foundation
import Observation

@Observable
@MainActor
final class ProductDetailsViewModel {
    var uiState: ProductDetailsUIState?
    var isLoading = false
    var failureMessage: String?

    private let useCase: GetProductDetailsUseCase
    private let repo: ProductDetailsRepo
    private let scanId: String
    private let preloadedData: ProductDetails?

    /// Init with scanId — fetches data from API.
    init(scanId: String,
         useCase: GetProductDetailsUseCase = DIContainer.shared.resolve(type: GetProductDetailsUseCase.self),
         repo: ProductDetailsRepo = DIContainer.shared.resolve(type: ProductDetailsRepo.self)) {
        self.scanId = scanId
        self.useCase = useCase
        self.repo = repo
        self.preloadedData = nil
    }

    /// Init with pre-loaded ScanDetail — no API call needed.
    init(scanDetail: ScanDetail,
         useCase: GetProductDetailsUseCase = DIContainer.shared.resolve(type: GetProductDetailsUseCase.self),
         repo: ProductDetailsRepo = DIContainer.shared.resolve(type: ProductDetailsRepo.self)) {
        self.scanId = scanDetail.scanId
        self.useCase = useCase
        self.repo = repo
        self.preloadedData = ProductDetails(from: scanDetail)
    }

    func loadProductDetails() async {
        // If we already have preloaded data, just use it
        if let preloaded = preloadedData {
            self.uiState = ProductDetailsUIState(from: preloaded)
            return
        }

        isLoading = true
        failureMessage = nil
        defer { isLoading = false }

        do {
            let details = try await useCase.execute(scanId: scanId)
            self.uiState = ProductDetailsUIState(from: details)
        } catch let error as NetworkError {
            failureMessage = error.localizedDescription
        } catch {
            failureMessage = "An unexpected error occurred."
        }
    }

    func toggleFavorite() {
        guard var currentState = uiState else { return }

        let newFavoriteStatus = !currentState.isFavorite
        currentState.isFavorite = newFavoriteStatus
        self.uiState = currentState

        Task {
            do {
                try await repo.updateFavorite(scanId: scanId, isFavorite: newFavoriteStatus)
            } catch {
                var revertedState = self.uiState
                revertedState?.isFavorite = !newFavoriteStatus
                self.uiState = revertedState
                self.failureMessage = "Failed to update favorite status."
            }
        }
    }
}
