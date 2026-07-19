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
            id: dto.barcode,
            barcode: dto.barcode,
            brand: firstBrand(from: dto.brands),
            name: dto.productName?.isEmpty == false ? dto.productName! : "Unknown product",
            imageURL: dto.imageUrl.flatMap(URL.init(string:)),
            healthTag: mapTag(dto.nutriscoreGrade)
        )
    }

    /// OFF returns brands as a comma-separated string, e.g. "Nestlé,Fanmilk".
    private func firstBrand(from brands: String?) -> String {
        guard let brands, !brands.isEmpty else { return "Unknown brand" }
        return brands
            .split(separator: ",")
            .first
            .map { $0.trimmingCharacters(in: .whitespaces) } ?? "Unknown brand"
    }

    /// Maps OFF's Nutri-Score letter grade (a–e) to a coarse health tag.
    /// Adjust this rule to whatever your app actually wants to show.
    private func mapTag(_ grade: String?) -> Product.HealthTag? {
        switch grade?.lowercased() {
        case "a", "b": return .healthy
        case "d", "e": return .highSugar
        case "c": return .custom("Moderate")
        default: return nil
        }
    }
}
