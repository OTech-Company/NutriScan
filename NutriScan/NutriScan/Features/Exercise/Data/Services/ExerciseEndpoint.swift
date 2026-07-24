//
//  ExerciseEndpoint.swift
//  NutriScan
//

import Foundation

enum ExerciseEndpoint: APIEndpoint {
    case getCategories
    case getExercises(request: FetchExercisesRequest)

    var baseURL: String {
        AppNetworkConfig.exercises.baseURL
    }

    var path: String {
        switch self {
        case .getCategories:
            return "/exercises/categories"
        case .getExercises:
            return "/exercises"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getCategories, .getExercises:
            return .get
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .getCategories:
            return nil
        case .getExercises(let request):
            var params: [String: String] = [
                "page": "\(request.page)",
                "limit": "\(request.limit)"
            ]
            if let bodyPart = request.bodyPart, !bodyPart.isEmpty, bodyPart.lowercased() != "all" {
                params["body_part"] = bodyPart.lowercased()
            }
            if let q = request.searchQuery, !q.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                params["q"] = q.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            return params
        }
    }

    var requiresAuth: Bool {
        false
    }
}
