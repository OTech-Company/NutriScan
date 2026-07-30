//
//  ScanHistoryEndpoint.swift
//  NutriScan
//

import Foundation

enum ScanHistoryEndpoint: APIEndpoint {
    case getScanHistory(page: Int, size: Int)
    
    var baseURL: String {
        return AppNetworkConfig.core.baseURL
    }
    
    var path: String {
        switch self {
        case .getScanHistory:
            return "/api/v1/scans"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .getScanHistory(let page, let size):
            return [
                "page": "\(page)",
                "size": "\(size)"
            ]
        }
    }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json"]
    }
    
    var requiresAuth: Bool {
        return true
    }
}
