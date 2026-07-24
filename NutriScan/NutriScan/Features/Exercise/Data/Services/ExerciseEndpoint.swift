//
//  ExerciseEndpoint.swift
//  NutriScan
//

import Foundation

enum ExerciseEndpoint: APIEndpoint {
    case getCategories

    var baseURL: String {
        AppNetworkConfig.exercises.baseURL
    }

    var path: String {
        switch self {
        case .getCategories:
            return "/exercises/categories"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getCategories:
            return .get
        }
    }

    var requiresAuth: Bool {
        false
    }
}
