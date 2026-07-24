import Foundation

enum ScanEndpoint: APIEndpoint {
    case uploadScan
    case getScanResult(scanId: String)
    case getScanHistory(page: Int, size: Int)

    var baseURL: String {
        AppNetworkConfig.core.baseURL
    }

    var path: String {
        switch self {
        case .uploadScan:
            return "/api/v1/scans"
        case .getScanResult(let scanId):
            return "/api/v1/scans/\(scanId)"
        case .getScanHistory:
            return "/api/v1/scans"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .uploadScan:
            return .post
        case .getScanResult, .getScanHistory:
            return .get
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .getScanHistory(let page, let size):
            return ["page": "\(page)", "size": "\(size)"]
        default:
            return nil
        }
    }

    var headers: [String: String] {
        [:]
    }

    var requiresAuth: Bool {
        true
    }
}
