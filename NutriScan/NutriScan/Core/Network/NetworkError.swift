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
    case serverError(statusCode: Int)
    case apiError(APIErrorResponse)
    case unauthorized
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:             return "Invalid URL"
        case .noInternet:             return "No internet connection"
        case .decodingFailed:         return "Failed to decode response"
        case .serverError(let code):  return "Server error: \(code)"
        case .apiError(let response): return response.userFriendlyMessage
        case .unauthorized:           return "Session expired. Please log in again."
        case .unknown(let error):     return error.localizedDescription
        }
    }
}
