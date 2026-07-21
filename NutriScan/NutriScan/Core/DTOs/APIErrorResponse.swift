//
//  APIErrorResponse.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 19/07/2026.
//

import Foundation

struct APIErrorResponse: Decodable {
    let timestamp: String?
    let status: Int?
    let error: String?
    let message: String?
    let details: [APIErrorDetail]?
    let path: String?
    
    // Keycloak / OAuth2 Standard Fields
    let errorDescription: String?

    enum CodingKeys: String, CodingKey {
        case timestamp, status, error, message, details, path
        case errorDescription = "error_description"
    }

    // Unified user-facing error message
    var userFriendlyMessage: String {
        // Keycloak / OAuth description
        if let errorDescription, !errorDescription.isEmpty {
            return errorDescription
        }
        // Standard backend message
        if let message, !message.isEmpty {
            return message
        }
        // Fallback error code
        if let error, !error.isEmpty {
            return error
        }
        return "An unexpected error occurred."
    }
}

struct APIErrorDetail: Decodable {
    let field: String
    let issue: String
}
