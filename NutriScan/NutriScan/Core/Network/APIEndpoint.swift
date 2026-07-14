//
//  APIEndpoint.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 14/07/2026.
//

import Foundation

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [String: String]? { get }
    var body: Encodable? { get }
    var headers: [String: String] { get }
}

extension APIEndpoint {
    var body: Encodable? { nil }
    var headers: [String: String] { [:] }

    var fullURL: URL? {
        var components = URLComponents(string: baseURL + path)
        if let queryParameters {
            components?.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        return components?.url
    }
}


