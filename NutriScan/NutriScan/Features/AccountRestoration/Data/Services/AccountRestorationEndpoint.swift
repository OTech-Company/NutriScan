//
//  AccountRestorationEndpoint.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

enum AccountRestorationEndpoint: APIEndpoint {
    case restoreAccount

    var baseURL: String { AppNetworkConfig.core.baseURL }

    var path: String {
        switch self {
        case .restoreAccount:
            return "/api/v1/users/profile/restore"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .restoreAccount:
            return .post
        }
    }

    var body: RequestBody {
        switch self {
        case .restoreAccount:
            return .none
        }
    }

    var requiresAuth: Bool { true }
}
