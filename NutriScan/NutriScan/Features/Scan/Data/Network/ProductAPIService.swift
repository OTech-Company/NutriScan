import Foundation

// MARK: - DTOs matching the API contract

struct ScanPageDTO: Decodable {
    let totalElements: Int
    let totalPages: Int
    let pageable: PageableDTO
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let size: Int
    let content: [ScanListItemDTO]
    let number: Int
    let sort: SortDTO
    let empty: Bool
}

struct PageableDTO: Decodable {
    let unpaged: Bool
    let pageNumber: Int
    let paged: Bool
    let pageSize: Int
    let offset: Int
    let sort: SortDTO
}

struct SortDTO: Decodable {
    let unsorted: Bool
    let sorted: Bool
    let empty: Bool
}

struct ScanListItemDTO: Decodable {
    let scanId: String
    let imageUrl: String?
    let verdict: String?
    let scannedAt: String?
}

struct ScanSubmissionDTO: Decodable {
    let scanId: String
    let status: String
}

struct ScanDetailDTO: Decodable {
    let scanId: String
    let status: String
    let scannedAt: String?
    let imageUrl: String?
    let foodSafetyResponse: FoodSafetyResponseDTO?
    let nutritionFacts: ScanNutritionFactsDTO?
}

struct FoodSafetyResponseDTO: Decodable {
    let verdict: String?
    let flaggedIngredients: [ScanFlaggedIngredientDTO]?
    let summary: String?
}

struct ScanFlaggedIngredientDTO: Decodable {
    let ingredient: String?
    let reason: String?
    let type: String?
    let name: [String]?
}

struct ScanNutritionFactsDTO: Decodable {
    let calories: Int?
    let proteinGrams: Double?
    let carbsGrams: Double?
    let fatG: Double?
    let fiberGrams: Double?
    let sugarG: Double?
    let sodiumMg: Double?
}

// MARK: - API Service Protocol

protocol ScanAPIServicing {
    func fetchScans(page: Int, size: Int) async throws -> ScanPageDTO
    func submitScan(imageData: Data) async throws -> ScanSubmissionDTO
    func fetchScanDetail(scanId: String) async throws -> ScanDetailDTO
}

// MARK: - API Service Implementation

final class ScanAPIService: ScanAPIServicing {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchScans(page: Int, size: Int) async throws -> ScanPageDTO {
        let endpoint = ScanEndpoint.fetchScans(page: page, size: size)
        do {
            return try await networkService.request(endpoint)
        } catch let error as NetworkError {
            switch error {
            case .decodingFailed:
                throw ScanError.decoding
            default:
                throw ScanError.network(error.localizedDescription)
            }
        } catch {
            throw ScanError.network(error.localizedDescription)
        }
    }

    func submitScan(imageData: Data) async throws -> ScanSubmissionDTO {
        let endpoint = ScanSubmitEndpoint(imageData: imageData)

        do {
            return try await networkService.request(endpoint)
        } catch let error as NetworkError {
            switch error {
            case .decodingFailed:
                throw ScanError.decoding
            default:
                throw ScanError.network(error.localizedDescription)
            }
        } catch {
            throw ScanError.network(error.localizedDescription)
        }
    }

    func fetchScanDetail(scanId: String) async throws -> ScanDetailDTO {
        let endpoint = ScanEndpoint.fetchScanDetail(scanId: scanId)
        do {
            return try await networkService.request(endpoint)
        } catch let error as NetworkError {
            switch error {
            case .decodingFailed:
                throw ScanError.decoding
            default:
                throw ScanError.network(error.localizedDescription)
            }
        } catch {
            throw ScanError.network(error.localizedDescription)
        }
    }
}

// MARK: - Multipart Upload Endpoint

private struct ScanSubmitEndpoint: APIEndpoint {
    let imageData: Data

    var baseURL: String { AppNetworkConfig.core.baseURL }
    var path: String { "/api/v1/scans" }
    var method: HTTPMethod { .post }
    var queryParameters: [String: String]? { nil }
    var body: RequestBody {
        var form = MultipartFormData()
        form.files.append(
            MultipartFormData.FilePart(
                name: "image",
                filename: "scan.jpg",
                mimeType: "image/jpeg",
                data: imageData
            )
        )
        return .multipart(form)
    }
    var headers: [String: String] { [:] }
    var requiresAuth: Bool { true }
}
