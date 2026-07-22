//
//  NewsRepository.swift
//  NewsFeed (Feature)
//
//  Bridges Data <-> Domain: fetches DTOs from the remote data source and
//  hands back mapped Domain entities, satisfying `NewsRepositoryProtocol`.
//

import Foundation

final class NewsRepository: NewsRepositoryProtocol {
    private let remoteDataSource: NewsRemoteDataSourceProtocol

    init(remoteDataSource: NewsRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchTopHeadlines(category: String) async throws -> [Article] {
        let response = try await remoteDataSource.fetchTopHeadlines(category: category)
        return ArticleMapper.map(response.articles)
    }

    func searchArticles(query: String) async throws -> [Article] {
        let response = try await remoteDataSource.fetchEverything(query: query)
        return ArticleMapper.map(response.articles)
    }
}
