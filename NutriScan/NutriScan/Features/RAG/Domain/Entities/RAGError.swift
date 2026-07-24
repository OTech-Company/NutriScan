//
//  RAGError.swift
//  NutriScan
//

import Foundation

enum RAGError: Error, LocalizedError {
    case emptyQuery
    case networkError(String)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .emptyQuery:
            return "Please enter a question."
        case .networkError(let message):
            return message
        case .decodingFailed:
            return "Failed to parse the response."
        }
    }
}
