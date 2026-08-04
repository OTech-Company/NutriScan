//
//  CaloriesTrackingEndPoint.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

enum CaloriesTrackingEndPoint: APIEndpoint {

    case getToday
    case getByDate(date: String)
    case addMeal(date: String, request: AddMealRequestDTO)
    case updateMeal(date: String, scanId: String, request: UpdateMealCountRequestDTO)
    case deleteMeal(date: String, scanId: String)
    case patchTracking(date: String, body: PatchCaloriesTrackingDTO)

    var baseURL: String { AppNetworkConfig.core.baseURL }

    var path: String {
        switch self {
        case .getToday:
            return "/api/v1/daily-tracking/today"
        case .getByDate(let date):
            return "/api/v1/daily-tracking/\(date)"
        case .addMeal(let date, _):
            return "/api/v1/daily-tracking/\(date)/meals"
        case .updateMeal(let date, let scanId, _):
            return "/api/v1/daily-tracking/\(date)/meals/\(scanId)"
        case .deleteMeal(let date, let scanId):
            return "/api/v1/daily-tracking/\(date)/meals/\(scanId)"
        case .patchTracking(let date, _):
            return "/api/v1/daily-tracking/\(date)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getToday, .getByDate:             return .get
        case .addMeal:                           return .post
        case .updateMeal:                        return .put
        case .deleteMeal:                        return .delete
        case .patchTracking:                     return .patch
        }
    }

    var body: RequestBody {
        switch self {
        case .addMeal(_, let request):
            return .json(request)
        case .updateMeal(_, _, let request):
            return .json(request)
        case .patchTracking(_, let patchBody):
            return .json(patchBody)
        default:
            return .none
        }
    }

    var queryParameters: [String: String]? {
        nil
    }
}
