import Foundation
import SwiftUI

@MainActor
final class ScanViewModel: ObservableObject {

    // MARK: - Published state consumed by ScanScreen

    @Published private(set) var detectedProduct: Product?
    @Published private(set) var isLookingUp: Bool = false
    @Published var errorMessage: String?

    private let lookupProductUseCase: LookupProductUseCase
    private var lastSubmittedBarcode: String?

    nonisolated init(lookupProductUseCase: LookupProductUseCase) {
        self.lookupProductUseCase = lookupProductUseCase
    }
    
    nonisolated static func makeDefault() -> ScanViewModel {
        ScanViewModel(lookupProductUseCase: DIContainer.shared.resolve(type: LookupProductUseCase.self))
    }
    // MARK: - Intents (called by the View)

    /// Called every time the camera layer detects a barcode string.
    func onBarcodeDetected(_ barcode: String) {
        // Avoid re-triggering a lookup for the same code while one is in flight,
        // and avoid re-fetching if we already matched this exact barcode.
        guard !isLookingUp, barcode != lastSubmittedBarcode else { return }
        lastSubmittedBarcode = barcode

        Task {
            await lookupProduct(barcode: barcode)
        }
    }

    func addTapped() {
        guard let product = detectedProduct else { return }
        // TODO: call an AddProductToLogUseCase here, following the same
        // pattern as LookupProductUseCase, when you build that flow.
        print("Added \(product.brand) - \(product.name)")
    }

    func dismissError() {
        errorMessage = nil
    }

    /// Reset so the next distinct barcode can trigger a fresh lookup
    /// (e.g. call this when the user taps "scan again" or the card is dismissed).
    func reset() {
        detectedProduct = nil
        lastSubmittedBarcode = nil
    }

    // MARK: - Private

    private func lookupProduct(barcode: String) async {
        isLookingUp = true
        defer { isLookingUp = false }

        do {
            let product = try await lookupProductUseCase.execute(barcode: barcode)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                detectedProduct = product
            }
        } catch let error as ProductError {
            errorMessage = error.userMessage
            lastSubmittedBarcode = nil // allow retry on the same code
        } catch {
            errorMessage = ProductError.unknown.userMessage
            lastSubmittedBarcode = nil
        }
    }
}
