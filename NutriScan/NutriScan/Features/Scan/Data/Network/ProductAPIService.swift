import Foundation



struct OpenFoodFactsResponse: Decodable {
    let code: String
    let status: Int
    let product: OpenFoodFactsProductDTO?
}

struct OpenFoodFactsProductDTO: Decodable {
    let productName: String?
    let brands: String?
    let imageUrl: String?
    let nutriscoreGrade: String?
}

/// What the repository actually consumes — envelope unwrapped, barcode attached.
struct ProductDTO {
    let barcode: String
    let productName: String?
    let brands: String?
    let imageUrl: String?
    let nutriscoreGrade: String?
}

protocol ProductAPIServicing {
    func fetchProduct(barcode: String) async throws -> ProductDTO
}

final class ProductAPIService: ProductAPIServicing {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchProduct(barcode: String) async throws -> ProductDTO {
        let endpoint = ProductEndpoint.fetchProduct(barcode: barcode)
        
        let envelope: OpenFoodFactsResponse
        do {
            envelope = try await networkService.request(endpoint)
        } catch let error as NetworkError {
            switch error {
            case .decodingFailed:
                throw ProductError.decoding
            default:
                throw ProductError.network(error.localizedDescription)
            }
        } catch {
            throw ProductError.network(error.localizedDescription)
        }

        // OFF returns status == 0 (with no `product`) when the barcode isn't found,
        // rather than an HTTP 404.
        guard envelope.status == 1, let product = envelope.product else {
            throw ProductError.notFound(barcode: barcode)
        }

        return ProductDTO(
            barcode: envelope.code,
            productName: product.productName,
            brands: product.brands,
            imageUrl: product.imageUrl,
            nutriscoreGrade: product.nutriscoreGrade
        )
    }
}
