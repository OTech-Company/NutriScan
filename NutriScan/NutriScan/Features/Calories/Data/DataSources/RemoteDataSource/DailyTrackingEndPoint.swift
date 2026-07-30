//
//  DailyTrackingEndPoint.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

enum DailyTrackingEndPoint: APIEndpoint {

    case getToday
    case getByDate(date: String)
    case getAll(page: Int, size: Int)
    case addMeal(date: String, request: AddMealRequestDTO)
    case updateMeal(date: String, scanId: String, request: UpdateMealCountRequestDTO)
    case deleteMeal(date: String, scanId: String)
    case patchTracking(date: String, body: PatchDailyTrackingDTO)
    case deleteTracking(date: String)

    var baseURL: String { AppNetworkConfig.core.baseURL }

    var path: String {
        switch self {
        case .getToday:
            return "/api/v1/daily-tracking/today"
        case .getByDate(let date):
            return "/api/v1/daily-tracking/\(date)"
        case .getAll:
            return "/api/v1/daily-tracking"
        case .addMeal(let date, _):
            return "/api/v1/daily-tracking/\(date)/meals"
        case .updateMeal(let date, let scanId, _):
            return "/api/v1/daily-tracking/\(date)/meals/\(scanId)"
        case .deleteMeal(let date, let scanId):
            return "/api/v1/daily-tracking/\(date)/meals/\(scanId)"
        case .patchTracking(let date, _):
            return "/api/v1/daily-tracking/\(date)"
        case .deleteTracking(let date):
            return "/api/v1/daily-tracking/\(date)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getToday, .getByDate, .getAll:    return .get
        case .addMeal:                           return .post
        case .updateMeal:                        return .put
        case .deleteMeal, .deleteTracking:       return .delete
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
        switch self {
        case .getAll(let page, let size):
            return ["page": "\(page)", "size": "\(size)"]
        default:
            return nil
        }
    }
}
