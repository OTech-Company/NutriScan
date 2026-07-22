//
//  NetworkServiceProtocol.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 14/07/2026.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    func request<T: Decodable>(_ endpoint: APIEndpoint, isRetry: Bool) async throws -> T
}

extension NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        try await request(endpoint, isRetry: false)
    }
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint, isRetry: Bool = false) async throws -> T {
        guard let url = endpoint.fullURL else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        // Auto-inject Authorization header from Keychain, unless the endpoint
        // already set one explicitly.
        if request.value(forHTTPHeaderField: "Authorization") == nil,
           let accessToken = try? KeychainManager.shared.get(key: .accessToken),
           !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        if let body = endpoint.body {
            if endpoint.headers["Content-Type"] == "application/x-www-form-urlencoded" {
                let data = try JSONEncoder().encode(AnyEncodable(body))
                guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    throw NetworkError.unknown(
                        NSError(domain: "NetworkService", code: -1, userInfo: [
                            NSLocalizedDescriptionKey: "Form-encoded body must be a flat key-value object."
                        ])
                    )
                }
                var components = URLComponents()
                components.queryItems = dictionary.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.httpBody = components.percentEncodedQuery?.data(using: .utf8)
            } else {
                request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
            }
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(URLError(.badServerResponse))
            }

            // 401 handling: refresh once, then re-run this ENTIRE function via
            // recursion (isRetry: true) instead of duplicating the request/decode
            // logic inline. This guarantees the retried call gets the exact same
            // status-code handling, decoding, and error mapping as any other request.
            let isTokenEndpoint = endpoint.path.contains("openid-connect/token")

            if httpResponse.statusCode == 401, !isRetry, !isTokenEndpoint {
                do {
                    _ = try await TokenRefresher.shared.refreshToken()
                } catch {
                    // Refresh token itself is dead — surface a clear, single error type.
                    throw NetworkError.unauthorized
                }
                return try await self.request(endpoint, isRetry: true)
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