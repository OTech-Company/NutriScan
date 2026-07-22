//
//  APIClient.swift
//  NewsFeed (Feature)
//
//  If your app already has a shared `APIClientProtocol` in Core/, delete
//  this and inject that one into NewsRemoteDataSource instead.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T
}

final class APIClient: APIClientProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let urlRequest: URLRequest
        do {
            urlRequest = try endpoint.asURLRequest()
        } catch {
            throw NetworkError.invalidURL
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw NetworkError.noInternet
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(URLError(.badServerResponse))
        }

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 429:
            throw NetworkError.rateLimited
        default:
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
