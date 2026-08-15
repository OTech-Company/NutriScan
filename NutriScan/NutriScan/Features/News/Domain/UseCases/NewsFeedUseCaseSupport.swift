import Foundation

/// A small headline use case retained for the app's smart-notification scheduler.
/// News presentation uses `FetchNewsFeedUseCaseProtocol` exclusively.
protocol FetchTopHeadlinesUseCaseProtocol {
    func execute(category: String) async throws -> [Article]
}

struct FetchTopHeadlinesUseCase: FetchTopHeadlinesUseCaseProtocol {
    private let repository: NewsRepositoryProtocol

    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(category: String) async throws -> [Article] {
        let result = try await repository.fetchTopHeadlines(category: category, page: 1, pageSize: 20)
        var seenTitles = Set<String>()
        return result.articles.filter { article in
            seenTitles.insert(article.title.lowercased()).inserted
        }
    }
}
