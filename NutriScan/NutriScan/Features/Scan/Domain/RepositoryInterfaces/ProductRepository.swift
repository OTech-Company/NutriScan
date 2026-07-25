import Foundation

/// Domain-owned protocol. The Data layer provides the concrete implementation.
/// This is what lets you swap network/local/mock implementations without
/// touching any Domain or Presentation code.
protocol ProductRepository {
    func fetchProduct(byBarcode barcode: String) async throws -> Product
}
