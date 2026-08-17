//
//  ScanHistoryEndpoint.swift
//  NutriScan
//

import Foundation

enum ScanHistoryEndpoint: APIEndpoint {
    case getScanHistory(page: Int, size: Int)
    case deleteScan(scanId: String)
    case getSuggestions(query: String)
    
    var baseURL: String {
        return AppNetworkConfig.core.baseURL
    }
    
    var path: String {
        switch self {
        case .getScanHistory:
            return "/api/v1/scans"
        case .deleteScan(let scanId):
            return "/api/v1/scans/\(scanId)"
        case .getSuggestions:
            return "/api/v1/scans/suggestions"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getScanHistory:
            return .get
        case .deleteScan:
            return .delete
        case .getSuggestions:
            return .get
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
        case .getSuggestions(let query):
            return ["query": query]
        }
    }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json"]
    }
    
    var requiresAuth: Bool {
        return true
    }
}
