//
//  ProductDetailsEndPoint.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation

enum ProductDetailsEndPoint : APIEndpoint {
    case getProductDetails(scanId: String)
    case updateFavorite(scanId: String, isFavorite: Bool)
    
    var baseURL: String {
        AppNetworkConfig.core.baseURL
    }
    
    var path: String {
        switch self {
        case .getProductDetails(let scanId):
            return "/api/v1/scans/\(scanId)"
        case .updateFavorite(let scanId, _):
            return "/api/v1/scans/\(scanId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProductDetails:
            return .get
        case .updateFavorite:
            return .patch
        }
    }
    
    var body: RequestBody {
        switch self {
        case .updateFavorite(_, let isFavorite):
            return .json(["favorite": isFavorite])
        default:
            return .none
        }
    }
}
