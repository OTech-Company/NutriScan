//
//  NewsRepositoryProtocol.swift
//  NewsFeed (Feature)
//
//  Lives in Domain so use cases (and the ViewModel, indirectly) never
//  depend on the concrete Data layer implementation, DTOs, or networking.
//

import Foundation

protocol NewsRepositoryProtocol {
    /// Top headlines for a fixed NewsAPI category (e.g. "health").
    func fetchTopHeadlines(category: String) async throws -> [Article]

    /// Free-text search against NewsAPI's `/everything` endpoint.
    func searchArticles(query: String) async throws -> [Article]
}
