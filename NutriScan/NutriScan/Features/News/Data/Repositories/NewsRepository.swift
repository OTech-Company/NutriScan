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

    func fetchTopHeadlines(category: String, page: Int, pageSize: Int) async throws -> NewsPage {
        let response = try await remoteDataSource.fetchTopHeadlines(
            category: category,
            page: page,
            pageSize: pageSize
        )
        return mapPage(response, page: page, pageSize: pageSize)
    }

    func searchArticles(query: String, page: Int, pageSize: Int) async throws -> NewsPage {
        let response = try await remoteDataSource.fetchEverything(
            query: query,
            page: page,
            pageSize: pageSize
        )
        return mapPage(response, page: page, pageSize: pageSize)
    }

    private func mapPage(_ response: NewsResponseDTO, page: Int, pageSize: Int) -> NewsPage {
        NewsPage(
            articles: ArticleMapper.map(response.articles),
            hasMore: page * pageSize < response.totalResults
        )
    }
}
