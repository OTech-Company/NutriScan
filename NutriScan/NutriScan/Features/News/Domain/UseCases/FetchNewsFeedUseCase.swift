import Foundation

protocol FetchNewsFeedUseCaseProtocol {
    func execute(
        availableInterests: [NewsInterest],
        selectedInterest: NewsInterest,
        searchText: String
    ) async throws -> [Article]
}

struct FetchNewsFeedUseCase: FetchNewsFeedUseCaseProtocol {
    private let repository: NewsRepositoryProtocol

    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        availableInterests: [NewsInterest],
        selectedInterest: NewsInterest,
        searchText: String
    ) async throws -> [Article] {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let conditionExpression = queryExpression(
            availableInterests: availableInterests,
            selectedInterest: selectedInterest
        )

        let articles: [Article]
        switch (trimmedSearch.isEmpty, conditionExpression) {
        case (true, nil):
            // With no profile conditions, behave like Discover and surface
            // the newest general stories instead of an empty personalized feed.
            articles = try await repository.fetchTopHeadlines(category: "general")
        case (true, .some(let conditions)):
            articles = try await repository.searchArticles(query: "(\(conditions))")
        case (false, nil):
            articles = try await repository.searchArticles(query: trimmedSearch)
        case (false, .some(let conditions)):
            articles = try await repository.searchArticles(
                query: "(\(trimmedSearch)) AND (\(conditions))"
            )
        }

        return articles
            .deduplicatedForNewsFeed()
            .sorted { $0.publishedAt > $1.publishedAt }
    }

    private func queryExpression(
        availableInterests: [NewsInterest],
        selectedInterest: NewsInterest
    ) -> String? {
        let selectedTerms: [String]
        if selectedInterest == .all {
            selectedTerms = availableInterests.compactMap(\.queryTerm)
        } else {
            selectedTerms = [selectedInterest.queryTerm].compactMap { $0 }
        }

        guard !selectedTerms.isEmpty else { return nil }
        return selectedTerms.joined(separator: " OR ")
    }
}

private extension Array where Element == Article {
    func deduplicatedForNewsFeed() -> [Article] {
        var seenURLs = Set<String>()
        var seenTitles = Set<String>()

        return filter { article in
            let normalizedTitle = article.title
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            guard seenURLs.insert(article.url).inserted else { return false }
            guard seenTitles.insert(normalizedTitle).inserted else { return false }
            return true
        }
    }
}
