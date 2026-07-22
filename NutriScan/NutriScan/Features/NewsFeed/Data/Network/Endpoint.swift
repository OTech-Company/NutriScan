//
//  Endpoint.swift
//  NewsFeed (Feature)
//
//  If your app already has a shared `Endpoint` protocol in Core/, delete
//  this and conform `NewsEndpoint` to that one instead.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var method: String { "GET" }

    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(string: NewsAPIConfig.baseURL + path)
        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
