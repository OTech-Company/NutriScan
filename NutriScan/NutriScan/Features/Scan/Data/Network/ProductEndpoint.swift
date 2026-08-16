import Foundation

enum ScanEndpoint: APIEndpoint {
    case fetchScans(page: Int, size: Int)
    case submitScan
    case submitBarcode(barcode: String)
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
        case .submitBarcode:
            return "/api/v1/scans/barcode"
        case .fetchScanDetail(let scanId):
            return "/api/v1/scans/\(scanId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchScans, .fetchScanDetail:
            return .get
        case .submitScan, .submitBarcode:
            return .post
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .fetchScans(let page, let size):
            return ["page": String(page), "size": String(size)]
        case .submitScan, .submitBarcode, .fetchScanDetail:
            return nil
        }
    }

    var body: RequestBody {
        switch self {
        case .submitBarcode(let barcode):
            return .json(ScanBarcodeRequestDTO(barcode: barcode))
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
