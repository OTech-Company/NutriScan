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
    case login(LoginRequestDTO)
    case forgotPassword(ForgotPasswordRequestDTO)
    case refreshToken(RefreshTokenRequestDTO)

    var baseURL: String {
        switch self {
        case .login, .refreshToken:
            return AppNetworkConfig.auth.baseURL
        default:
            return AppNetworkConfig.core.baseURL
        }
    }

    var path: String {
        switch self {
        case .register:
            return "auth/register"
        case .resendVerification:
            return "auth/resend-verification"
        case .login, .refreshToken:
            return "realms/nutriscan/protocol/openid-connect/token"
        case .forgotPassword:
            return "auth/forgot-password"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .register, .resendVerification, .login, .forgotPassword, .refreshToken:
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
        case .login(let dto):
            return dto
        case .forgotPassword(let dto):
            return dto
        case .refreshToken(let dto):
            return dto
        }
    }

    var headers: [String: String] {
        switch self {
        case .login, .refreshToken:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
