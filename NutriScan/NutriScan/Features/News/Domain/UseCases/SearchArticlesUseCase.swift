//
//  SearchArticlesUseCase.swift
//  NewsFeed (Feature)
//

import Foundation

protocol SearchArticlesUseCaseProtocol {
    func execute(query: String) async throws -> [Article]
}

struct SearchArticlesUseCase: SearchArticlesUseCaseProtocol {
    private let repository: NewsRepositoryProtocol

    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [Article] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        let articles = try await repository.searchArticles(query: trimmed)
        return articles
            .deduplicatedByTitle()
            .sorted { $0.publishedAt > $1.publishedAt }
    }
}

extension Array where Element == Article {
    func deduplicatedByTitle() -> [Article] {
        var seenTitles = Set<String>()
        return filter { article in
            let key = article.title.lowercased()
            guard !seenTitles.contains(key) else { return false }
            seenTitles.insert(key)
            return true
        }
    }
}
