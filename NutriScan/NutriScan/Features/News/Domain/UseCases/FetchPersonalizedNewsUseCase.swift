import Foundation

protocol FetchPersonalizedNewsUseCaseProtocol {
    func execute() async throws -> [Article]
}

final class FetchPersonalizedNewsUseCase: FetchPersonalizedNewsUseCaseProtocol {
    private let newsRepository: NewsRepositoryProtocol
    private let fetchAndCacheProfileUseCase: FetchAndCacheProfileUseCaseProtocol
    private let observeProfileUseCase: ObserveProfileUseCaseProtocol

    init(
        newsRepository: NewsRepositoryProtocol = NewsRepository(
            remoteDataSource: NewsRemoteDataSource(networkService: NetworkService())
        ),
        fetchAndCacheProfileUseCase: FetchAndCacheProfileUseCaseProtocol = FetchAndCacheProfileUseCase(),
        observeProfileUseCase: ObserveProfileUseCaseProtocol = ObserveProfileUseCase()
    ) {
        self.newsRepository = newsRepository
        self.fetchAndCacheProfileUseCase = fetchAndCacheProfileUseCase
        self.observeProfileUseCase = observeProfileUseCase
    }

    func execute() async throws -> [Article] {
        try await fetchAndCacheProfileUseCase.execute()
        let store = observeProfileUseCase.execute()

        guard let profile = store.currentProfile else { return [] }

        var terms: [String] = []

        for allergy in profile.allergies {
            terms.append("\(allergy.name) allergie")
        }

        for disease in profile.diseases {
            terms.append("\(disease.name) disease")
        }

        guard !terms.isEmpty else { return [] }

        let query = "(\(terms.joined(separator: " OR ")))"

        let fullURL = "https://newsapi.org/v2/everything?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)&apiKey=a06999badc0d4b2ebbe795b1a4891167"
        print("[PersonalizedNews] URL: \(fullURL)")

        let articles = try await newsRepository.searchArticles(query: query)
        return Array(articles.prefix(10))
    }
}
