import Foundation

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
