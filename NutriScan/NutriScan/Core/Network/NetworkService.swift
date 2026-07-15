//
//  NetworkServiceProtocol.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 14/07/2026.
//


//
//  NetworkService.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.fullURL else {
            throw NetworkError.invalidURL
        }
        
        var headers: [String: String] {
            [
                "X-Shopify-Access-Token": ShopifyConfig.accessToken,
                "Content-Type": "application/json"
            ]
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let body = endpoint.body {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(AnyEncodable(body))
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(URLError(.badServerResponse))
            }

            guard (200...299).contains(httpResponse.statusCode) else {

                if let json = String(data: data, encoding: .utf8) {
                    print("Status:", httpResponse.statusCode)
                    print("Response:", json)
                }

                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            } catch {
                print("NetworkError.decodingFailed : \(NetworkError.decodingFailed)")
                throw NetworkError.decodingFailed
            }

        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}