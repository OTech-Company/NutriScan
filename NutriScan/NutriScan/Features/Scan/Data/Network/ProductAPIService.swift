import Foundation

/// Data Transfer Object — mirrors the API's JSON shape exactly.
/// Kept separate from the Domain `Product` entity on purpose: if the backend
/// renames a field or changes shape, only this file and its mapper change.
struct ProductDTO: Decodable {
    let barcode: String
    let productId: String
    let brandName: String
    let productName: String
    let imageUrl: String?
    let tag: String?
}

protocol ProductAPIServicing {
    func fetchProduct(barcode: String) async throws -> ProductDTO
}

final class ProductAPIService: ProductAPIServicing {

    private let session: URLSession
    private let baseURL: URL

    init(session: URLSession = .shared,
         baseURL: URL = URL(string: "https://api.yourapp.com")!) {
        self.session = session
        self.baseURL = baseURL
    }

    func fetchProduct(barcode: String) async throws -> ProductDTO {
        let url = baseURL.appendingPathComponent("products/\(barcode)")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw ProductError.network(error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse else {
            throw ProductError.unknown
        }

        switch http.statusCode {
        case 200:
            do {
                return try JSONDecoder().decode(ProductDTO.self, from: data)
            } catch {
                throw ProductError.decoding
            }
        case 404:
            throw ProductError.notFound(barcode: barcode)
        default:
            throw ProductError.network("Server returned status \(http.statusCode)")
        }
    }
}
