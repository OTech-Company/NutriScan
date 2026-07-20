//
//  AppNetworkConfig.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 16/07/2026.
//


import Foundation

enum AppNetworkConfig {
    case core // The main url
    case auth
    case openFoodFacts
    
    var baseURL: String {
        switch self {
        case .core:
            return "https://nutriscan.dev" // the test backend url
        case .auth:
            return "https://auth.nutriscan.dev" // used with Login, refresh, logout, and the Google flow
        case .openFoodFacts:
            return "https://world.openfoodfacts.org/api/v2/product"
        }
    }
}

