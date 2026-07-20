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

struct EmptyResponse: Decodable {}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let tokenProvider: TokenProviding?

    init(session: URLSession = .shared, tokenProvider: TokenProviding? = nil) {
        self.session = session
        self.tokenProvider = tokenProvider
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.fullURL else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        if endpoint.requiresAuth, let token = await tokenProvider?.accessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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

            guard (200...299).contains(httpResponse.statusCode) else {
                let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, apiError: apiError)
            }

            if httpResponse.statusCode == 204 || data.isEmpty, let empty = EmptyResponse() as? T {
                return empty
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = endpoint.keyDecodingStrategy
                return try decoder.decode(T.self, from: data)
            } catch {
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
    init(_ wrapped: some Encodable) { _encode = wrapped.encode }
    func encode(to encoder: Encoder) throws { try _encode(encoder) }
}

private extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "+&=") // these need escaping inside form values, unlike in a query string
        return allowed
    }()
}
