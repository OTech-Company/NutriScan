import Foundation



struct OpenFoodFactsResponse: Decodable {
    let code: String
    let status: Int
    let product: OpenFoodFactsProductDTO?

    enum CodingKeys: String, CodingKey {
        case code, status, product
    }
}

struct OpenFoodFactsProductDTO: Decodable {
    let productName: String?
    let brands: String?
    let imageUrl: String?
    let nutriscoreGrade: String?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case imageUrl = "image_url"
        case nutriscoreGrade = "nutriscore_grade"
    }
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

    private let session: URLSession
    private let baseURL: URL

    init(session: URLSession = .shared,
         baseURL: URL = URL(string: "https://world.openfoodfacts.org/api/v2/product/")!) {
        self.session = session
        self.baseURL = baseURL
    }

    func fetchProduct(barcode: String) async throws -> ProductDTO {
        // Open Food Facts: GET /api/v2/product/{barcode}.json
        // `fields` trims the response to just what we use, and OFF asks every
        // client to identify itself via User-Agent (they'll reach out if an
        // integration misbehaves, rather than just blocking it outright).
        var components = URLComponents(
            url: baseURL.appendingPathComponent("\(barcode).json"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "fields", value: "code,product_name,brands,image_url,nutriscore_grade")
        ]
        guard let url = components.url else {
            throw ProductError.unknown
        }

        var request = URLRequest(url: url)
        request.setValue("NutriScan - iOS - Version 1.0", forHTTPHeaderField: "User-Agent")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw ProductError.network(error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw ProductError.network("Unexpected server response")
        }

        let envelope: OpenFoodFactsResponse
        do {
            envelope = try JSONDecoder().decode(OpenFoodFactsResponse.self, from: data)
        } catch {
            throw ProductError.decoding
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
