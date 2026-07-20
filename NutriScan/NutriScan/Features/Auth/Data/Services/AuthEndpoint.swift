//
//  AuthEndpoint.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 19/07/2026.
//

import Foundation

enum AuthEndpoint: APIEndpoint {
    case register(RegisterRequestDTO)
    case resendVerification(ResendVerificationRequestDTO)

    var baseURL: String {
        return AppNetworkConfig.core.baseURL
    }

    var path: String {
        switch self {
        case .register:
            return "auth/register"
        case .resendVerification:
            return "auth/resend-verification"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .register, .resendVerification:
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
        case .resendVerification(let dto):
            return dto
        }
    }

    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
}
