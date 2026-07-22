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
            return "/api/v1/auth/register"
        case .resendVerification:
            return "/api/v1/auth/resend-verification"
        case .login, .refreshToken:
            return "realms/nutriscan/protocol/openid-connect/token"
        case .forgotPassword:
            return "/api/v1/auth/forgot-password"
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

    var body: RequestBody {
        switch self {
        case .register(let dto):
            return .json(dto)
        case .resendVerification(let dto):
            return .json(dto)
        case .login(let dto):
            return .formURLEncoded([
                "username": dto.username,
                "password": dto.password,
                "grant_type": dto.grantType,
                "client_id": dto.clientId
            ])
        case .forgotPassword(let dto):
            return .json(dto)
        case .refreshToken(let dto):
            return .formURLEncoded([
                "refresh_token": dto.refreshToken,
                "grant_type": dto.grantType,
                "client_id": dto.clientId
            ])
        }
    }

    var headers: [String: String] {
        [:]
    }

    var requiresAuth: Bool {
        false
    }
}
