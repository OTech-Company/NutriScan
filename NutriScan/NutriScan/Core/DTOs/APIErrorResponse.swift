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
}

struct APIErrorDetail: Decodable {
    let field: String
    let issue: String
}
