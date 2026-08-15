//
//  NewsRemoteDataSource.swift
//  NewsFeed (Feature)
//
//  Data source = raw I/O only. It knows about endpoints and DTOs but
//  nothing about domain entities or business rules.
//

import Foundation

protocol NewsRemoteDataSourceProtocol {
    func fetchTopHeadlines(category: String, page: Int, pageSize: Int) async throws -> NewsResponseDTO
    func fetchEverything(query: String, page: Int, pageSize: Int) async throws -> NewsResponseDTO
}

final class NewsRemoteDataSource: NewsRemoteDataSourceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchTopHeadlines(category: String, page: Int, pageSize: Int) async throws -> NewsResponseDTO {
        try await networkService.request(
            NewsEndpoint.topHeadlines(category: category, page: page, pageSize: pageSize)
        )
    }

    func fetchEverything(query: String, page: Int, pageSize: Int) async throws -> NewsResponseDTO {
        try await networkService.request(
            NewsEndpoint.everything(query: query, page: page, pageSize: pageSize)
        )
    }
}
