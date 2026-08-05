//
//  SettingsEndpoint.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

enum SettingsEndpoint: APIEndpoint {
    case deleteAccount

    var baseURL: String { AppNetworkConfig.core.baseURL }

    var path: String {
        switch self {
        case .deleteAccount:
            return "/api/v1/users/profile"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .deleteAccount:
            return .delete
        }
    }

    var body: RequestBody {
        switch self {
        case .deleteAccount:
            return .none
        }
    }

    var requiresAuth: Bool { true }
}
