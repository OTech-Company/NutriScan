//
//  CaloriesHistoryEndpoint.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import Foundation

enum CaloriesHistoryEndpoint: APIEndpoint {
    case history(page: Int, size: Int)
    case historyByDate(String)

    var baseURL: String { AppNetworkConfig.core.baseURL }

    var path: String {
        switch self {
        case .history:
            return "/api/v1/daily-tracking"
        case .historyByDate(let date):
            return "/api/v1/daily-tracking/\(date)"
        }
    }

    var method: HTTPMethod { .get }

    var queryParameters: [String: String]? {
        switch self {
        case .history(let page, let size):
            return ["page": "\(page)", "size": "\(size)"]
        case .historyByDate:
            return nil
        }
    }
}
