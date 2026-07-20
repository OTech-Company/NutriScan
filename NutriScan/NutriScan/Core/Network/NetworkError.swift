//
//  NetworkError.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 14/07/2026.
//

import Foundation


enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noInternet
    case decodingFailed
    case serverError(statusCode: Int, apiError: APIErrorResponse?)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noInternet: return "No internet connection"
        case .decodingFailed: return "Failed to decode response"
        case .serverError(let code, let apiError):
            return apiError?.message ?? "Server error: \(code)"
        case .unknown(let error): return error.localizedDescription
        }
    }
}
