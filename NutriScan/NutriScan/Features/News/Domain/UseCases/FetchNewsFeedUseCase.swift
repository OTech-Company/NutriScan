import Foundation

protocol FetchNewsFeedUseCaseProtocol {
    func execute(
        availableInterests: [NewsInterest],
        selectedInterest: NewsInterest,
        searchText: String,
        page: Int,
        pageSize: Int
    ) async throws -> NewsPage
}

struct FetchNewsFeedUseCase: FetchNewsFeedUseCaseProtocol {
    private let repository: NewsRepositoryProtocol

    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        availableInterests: [NewsInterest],
        selectedInterest: NewsInterest,
        searchText: String,
        page: Int,
        pageSize: Int
    ) async throws -> NewsPage {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        let result: NewsPage
        if selectedInterest == .all {
            let profileInterests = availableInterests.filter { $0 != .all }
            if profileInterests.isEmpty {
                result = try await fetchDiscoverFeed(
                    searchText: trimmedSearch,
                    page: page,
                    pageSize: pageSize
                )
            } else {
                result = try await fetchAllInterestFeeds(
                    profileInterests,
                    searchText: trimmedSearch,
                    page: page,
                    pageSize: pageSize
                )
            }
        } else if let queryTerm = selectedInterest.queryTerm {
            result = try await repository.searchArticles(
                query: query(searchText: trimmedSearch, interestTerm: queryTerm),
                page: page,
                pageSize: pageSize
            )
        } else {
            result = try await fetchDiscoverFeed(
                searchText: trimmedSearch,
                page: page,
                pageSize: pageSize
            )
        }

        return NewsPage(
            articles: result.articles
                .deduplicatedForNewsFeed()
                .sorted { $0.publishedAt > $1.publishedAt },
            hasMore: result.hasMore
        )
    }

    private func fetchAllInterestFeeds(
        _ interests: [NewsInterest],
        searchText: String,
        page: Int,
        pageSize: Int
    ) async throws -> NewsPage {
        var mergedArticles: [Article] = []
        var firstFailure: Error?
        var successfulRequestCount = 0
        var hasMore = false

        for interest in interests {
            guard let queryTerm = interest.queryTerm else { continue }

            do {
                let result = try await repository.searchArticles(
                    query: query(searchText: searchText, interestTerm: queryTerm),
                    page: page,
                    pageSize: pageSize
                )
                successfulRequestCount += 1
                mergedArticles.append(contentsOf: result.articles)
                hasMore = hasMore || result.hasMore
            } catch {
                if Task.isCancelled {
                    throw error
                }
                firstFailure = firstFailure ?? error
            }
        }

        if successfulRequestCount == 0, let firstFailure {
            throw firstFailure
        }

        return NewsPage(articles: mergedArticles, hasMore: hasMore)
    }

    private func fetchDiscoverFeed(
        searchText: String,
        page: Int,
        pageSize: Int
    ) async throws -> NewsPage {
        if searchText.isEmpty {
            // With no profile conditions, behave like Discover and surface
            // the newest general stories instead of an empty personalized feed.
            return try await repository.fetchTopHeadlines(
                category: "general",
                page: page,
                pageSize: pageSize
            )
        }
        return try await repository.searchArticles(
            query: searchText,
            page: page,
            pageSize: pageSize
        )
    }

    private func query(searchText: String, interestTerm: String) -> String {
        guard !searchText.isEmpty else { return "(\(interestTerm))" }
        return "(\(searchText)) AND (\(interestTerm))"
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
