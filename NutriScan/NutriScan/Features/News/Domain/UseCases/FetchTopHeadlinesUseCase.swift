//
//  FetchTopHeadlinesUseCase.swift
//  NewsFeed (Feature)
//
//  A use case encapsulates one piece of business logic and depends only
//  on the domain repository protocol, keeping the ViewModel free of
//  orchestration details and making each behavior independently testable.
//

import Foundation

protocol FetchTopHeadlinesUseCaseProtocol {
    func execute(category: String) async throws -> [Article]
}

struct FetchTopHeadlinesUseCase: FetchTopHeadlinesUseCaseProtocol {
    private let repository: NewsRepositoryProtocol

    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(category: String) async throws -> [Article] {
        let articles = try await repository.fetchTopHeadlines(category: category)
        return articles.deduplicatedByTitle()
    }
}
