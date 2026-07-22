//
//  NewsRemoteDataSource.swift
//  NewsFeed (Feature)
//
//  Data source = raw I/O only. It knows about endpoints and DTOs but
//  nothing about domain entities or business rules.
//

import Foundation

protocol NewsRemoteDataSourceProtocol {
    func fetchTopHeadlines(category: String) async throws -> NewsResponseDTO
    func fetchEverything(query: String) async throws -> NewsResponseDTO
}

final class NewsRemoteDataSource: NewsRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchTopHeadlines(category: String) async throws -> NewsResponseDTO {
        try await apiClient.request(
            NewsEndpoint.topHeadlines(category: category),
            as: NewsResponseDTO.self
        )
    }

    func fetchEverything(query: String) async throws -> NewsResponseDTO {
        try await apiClient.request(
            NewsEndpoint.everything(query: query),
            as: NewsResponseDTO.self
        )
    }
}
