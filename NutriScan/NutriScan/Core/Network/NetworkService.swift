//
//  NetworkServiceProtocol.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 14/07/2026.
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

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            if endpoint.headers["Content-Type"] == "application/x-www-form-urlencoded" {
                if let data = try? JSONEncoder().encode(AnyEncodable(body)),
                   let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    var components = URLComponents()
                    components.queryItems = dictionary.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                    request.httpBody = components.percentEncodedQuery?.data(using: .utf8)
                }
            } else {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(AnyEncodable(body))
            }
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
                let decoder = JSONDecoder()
                if let apiError = try? decoder.decode(APIErrorResponse.self, from: data) {
                    throw NetworkError.apiError(apiError)
                }

                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }

            do {
                let decoder = JSONDecoder()
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

struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    
    init(_ wrapped: some Encodable) {
        _encode = wrapped.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
