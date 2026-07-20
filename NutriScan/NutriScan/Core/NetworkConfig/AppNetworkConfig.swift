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
    
    var baseURL: String {
        switch self {
        case .core:
            return "https://nutriscan.dev/api/v1/"
        case .auth:
            return "https://auth.nutriscan.ai"
        }
    }
}

