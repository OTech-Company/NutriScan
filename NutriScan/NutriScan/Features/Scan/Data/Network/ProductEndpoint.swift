//
//  ProductEndpoint.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 20/07/2026.
//

import Foundation

enum ProductEndpoint: APIEndpoint {
    case fetchProduct(barcode: String)
    
    var baseURL: String {
        return AppNetworkConfig.openFoodFacts.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchProduct(let barcode):
            return "/\(barcode).json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchProduct:
            return ["fields": "code,product_name,brands,image_url,nutriscore_grade"]
        }
    }
    
    var headers: [String : String] {
        return ["User-Agent": "NutriScan - iOS - Version 1.0"]
    }
    
    var requiresAuth: Bool {
        return false
    }
}
