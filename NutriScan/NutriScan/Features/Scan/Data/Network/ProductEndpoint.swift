import Foundation

enum ScanEndpoint: APIEndpoint {
    case fetchScans(page: Int, size: Int)
    case submitScan
    case fetchScanDetail(scanId: String)

    var baseURL: String {
        return AppNetworkConfig.core.baseURL
    }

    var path: String {
        switch self {
        case .fetchScans:
            return "/api/v1/scans"
        case .submitScan:
            return "/api/v1/scans"
        case .fetchScanDetail(let scanId):
            return "/api/v1/scans/\(scanId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchScans, .fetchScanDetail:
            return .get
        case .submitScan:
            return .post
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .fetchScans(let page, let size):
            return ["page": String(page), "size": String(size)]
        case .submitScan, .fetchScanDetail:
            return nil
        }
    }

    var body: RequestBody {
        switch self {
        case .submitScan:
            return .none
        default:
            return .none
        }
    }

    var headers: [String: String] {
        return [:]
    }

    var requiresAuth: Bool {
        return true
    }
}
