//
//  RAGEndpoint.swift
//  NutriScan
//

import Foundation

enum RAGEndpoint: APIEndpoint {
    case query(_ request: RAGQueryDTO)

    var baseURL: String {
        AppNetworkConfig.rag.baseURL
    }

    var path: String {
        "/api/query"
    }

    var method: HTTPMethod {
        .post
    }

    var body: RequestBody {
        switch self {
        case .query(let dto):
            return .json(dto)
        }
    }

    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }

    var requiresAuth: Bool {
        false
    }
}
