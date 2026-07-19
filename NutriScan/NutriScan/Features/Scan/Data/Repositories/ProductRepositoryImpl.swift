import Foundation

final class ProductRepositoryImpl: ProductRepository {

    private let apiService: ProductAPIServicing

    init(apiService: ProductAPIServicing = ProductAPIService()) {
        self.apiService = apiService
    }

    func fetchProduct(byBarcode barcode: String) async throws -> Product {
        let dto = try await apiService.fetchProduct(barcode: barcode)
        return map(dto)
    }

    // MARK: - Mapping

    private func map(_ dto: ProductDTO) -> Product {
        Product(
            id: dto.productId,
            barcode: dto.barcode,
            brand: dto.brandName,
            name: dto.productName,
            imageURL: dto.imageUrl.flatMap(URL.init(string:)),
            healthTag: mapTag(dto.tag)
        )
    }

    private func mapTag(_ raw: String?) -> Product.HealthTag? {
        switch raw?.lowercased() {
        case "healthy": return .healthy
        case "probiotic": return .probiotic
        case "high_sugar", "highsugar": return .highSugar
        case .some(let other) where !other.isEmpty: return .custom(other)
        default: return nil
        }
    }
}
