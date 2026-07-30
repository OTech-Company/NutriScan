//
//  DailyTrackingEndpoint.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 30/07/2026.
//

import Foundation

// MARK: - Request Body Structs

/// Body for POST /api/v1/daily-tracking/{date}/meals
struct AddMealRequestBody: Encodable {
    let scanId: String
    let mealCnt: Int
}

/// Body for PUT /api/v1/daily-tracking/{date}/meals/{scanId}
struct UpdateMealRequestBody: Encodable {
    let mealCnt: Int
}

// MARK: - Endpoint

enum DailyTrackingEndpoint: APIEndpoint {

    /// POST /api/v1/daily-tracking/{date}/meals
    /// Adds a new product to today's daily meals.
    case addMeal(date: String, scanId: String, mealCnt: Int)

    /// PUT /api/v1/daily-tracking/{date}/meals/{scanId}
    /// Updates the meal count for an existing product in today's daily meals.
    case updateMeal(date: String, scanId: String, mealCnt: Int)

    // MARK: - APIEndpoint

    var baseURL: String {
        return AppNetworkConfig.core.baseURL
    }

    var path: String {
        switch self {
        case .addMeal(let date, _, _):
            return "/api/v1/daily-tracking/\(date)/meals"
        case .updateMeal(let date, let scanId, _):
            return "/api/v1/daily-tracking/\(date)/meals/\(scanId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .addMeal:
            return .post
        case .updateMeal:
            return .put
        }
    }

    var queryParameters: [String: String]? {
        return nil
    }

    var body: RequestBody {
        switch self {
        case .addMeal(_, let scanId, let mealCnt):
            return .json(AddMealRequestBody(scanId: scanId, mealCnt: mealCnt))
        case .updateMeal(_, _, let mealCnt):
            return .json(UpdateMealRequestBody(mealCnt: mealCnt))
        }
    }

    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }

    var requiresAuth: Bool {
        return true
    }
}
