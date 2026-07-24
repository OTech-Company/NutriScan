//
//  AppNetworkConfig.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 16/07/2026.
//


import Foundation

enum AppNetworkConfig {
    case core
    case auth
    case openFoodFacts
    case exercises
    
    var baseURL: String {
        switch self {
        case .core:
            // Profile (and other core) endpoints include `/api/v1/...` in their path.
            return "https://nutriscan.dev"
        case .auth:
            // Auth paths have no leading slash (e.g. `realms/...`), so keep the trailing `/`.
            return "https://auth.nutriscan.dev/"
        case .openFoodFacts:
            return "https://world.openfoodfacts.org/api/v2/product"
        case .exercises:
            return "https://exercises-dataset-mu.vercel.app"
        }
    }
}
