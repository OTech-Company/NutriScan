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
        let articles = try await repository.fetchTopHeadlines(category: category)
        var seenTitles = Set<String>()
        return articles.filter { article in
            seenTitles.insert(article.title.lowercased()).inserted
        }
    }
}
