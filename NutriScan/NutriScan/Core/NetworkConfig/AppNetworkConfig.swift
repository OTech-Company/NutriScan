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
    
    var baseURL: String {
        switch self {
        case .core:
            return "http://localhost:8080" // local backend url
        case .auth:
            return "https://auth.nutriscan.ai" // used with Login, refresh, logout, and the Google flow
        }
    }
}

