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
    var body: RequestBody { get }
    var headers: [String: String] { get }
    var requiresAuth: Bool { get }
}

extension APIEndpoint {
    var queryParameters: [String: String]? { nil }
    var body: RequestBody { .none }
    var headers: [String: String] { [:] }
    var requiresAuth: Bool { true } // most endpoints need a token; auth endpoints opt out

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
