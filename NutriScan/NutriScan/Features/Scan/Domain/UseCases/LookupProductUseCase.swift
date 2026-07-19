import Foundation

/// One use case = one user intention. The ViewModel talks to this,
/// never directly to the repository or network.
protocol LookupProductUseCase {
    func execute(barcode: String) async throws -> Product
}

final class LookupProductUseCaseImpl: LookupProductUseCase {

    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func execute(barcode: String) async throws -> Product {
        // This is the place for business rules beyond a raw fetch, e.g.:
        // - validating barcode format/checksum before hitting the network
        // - falling back to a cached/local product if the network fails
        // - applying "is this healthy?" tagging logic if it's not server-side
        guard barcode.count >= 6 else {
            throw ProductError.notFound(barcode: barcode)
        }
        return try await repository.fetchProduct(byBarcode: barcode)
    }
}
