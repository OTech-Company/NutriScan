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

struct EmptyResponse: Decodable {}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint, isRetry: Bool = false) async throws -> T {
        guard let url = endpoint.fullURL else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        // Attach Authorization header from Keychain if required
        if endpoint.requiresAuth,
           request.value(forHTTPHeaderField: "Authorization") == nil {
            if let accessToken = try? KeychainManager.shared.get(key: .accessToken),
               !accessToken.isEmpty {
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        }

        switch endpoint.body {
        case .none:
            break

        case .json(let encodable):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = endpoint.keyEncodingStrategy
            request.httpBody = try encoder.encode(AnyEncodable(encodable))
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        case .formURLEncoded(let params):
            let encoded = params.map { key, value in
                "\(key.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? value)"
            }.joined(separator: "&")
            request.httpBody = encoded.data(using: .utf8)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        case .multipart(let form):
            request.httpBody = form.encode()
            request.setValue(form.contentTypeHeader, forHTTPHeaderField: "Content-Type")
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

            if httpResponse.statusCode == 204 || data.isEmpty, let empty = EmptyResponse() as? T {
                return empty
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = endpoint.keyDecodingStrategy
                return try decoder.decode(T.self, from: data)
            } catch {
                if let json = String(data: data, encoding: .utf8) {
                    print("Decoding failed for \(T.self):", error)
                    print("Response:", json)
                }
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

private extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "+&=") // these need escaping inside form values, unlike in a query string
        return allowed
    }()
}
