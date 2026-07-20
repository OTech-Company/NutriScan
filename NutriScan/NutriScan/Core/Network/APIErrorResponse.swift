//
//  APIErrorResponse.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 20/07/2026.
//

import Foundation

struct APIErrorResponse: Decodable {
    let timestamp: String?
    let status: Int?
    let error: String?
    let message: String?
    let details: [Detail]?
    let path: String?

    struct Detail: Decodable {
        let field: String
        let issue: String
    }
}
