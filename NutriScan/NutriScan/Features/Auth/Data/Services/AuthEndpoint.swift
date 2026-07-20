//
//  AuthEndpoint.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 19/07/2026.
//

import Foundation

enum AuthEndpoint: APIEndpoint {
    case register(RegisterRequestDTO)

    var baseURL: String {
        return AppNetworkConfig.core.baseURL
    }

    var path: String {
        switch self {
        case .register:
            return "auth/register"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .register:
            return .post
        }
    }

    var queryParameters: [String: String]? {
        return nil
    }

    var body: Encodable? {
        switch self {
        case .register(let dto):
            return dto
        }
    }

    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
}
