//
//  ScanHistoryEndpoint.swift
//  NutriScan
//

import Foundation

enum ScanHistoryEndpoint: APIEndpoint {
    case getScanHistory(page: Int, size: Int)
    case deleteScan(scanId: String)
    
    var baseURL: String {
        return AppNetworkConfig.core.baseURL
    }
    
    var path: String {
        switch self {
        case .getScanHistory:
            return "/api/v1/scans"
        case .deleteScan(let scanId):
            return "/api/v1/scans/\(scanId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getScanHistory:
            return .get
        case .deleteScan:
            return .delete
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .getScanHistory(let page, let size):
            return [
                "page": "\(page)",
                "size": "\(size)"
            ]
        case .deleteScan:
            return nil
        }
    }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json"]
    }
    
    var requiresAuth: Bool {
        return true
    }
}
