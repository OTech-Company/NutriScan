import Foundation

protocol FetchPersonalizedNewsUseCaseProtocol {
    func execute() async throws -> [Article]
}

final class FetchPersonalizedNewsUseCase: FetchPersonalizedNewsUseCaseProtocol {
    private let newsRepository: NewsRepositoryProtocol
    private let profileUseCase: GetEditProfileUseCaseProtocol

    init(
        newsRepository: NewsRepositoryProtocol = NewsRepository(
            remoteDataSource: NewsRemoteDataSource(networkService: NetworkService())
        ),
        profileUseCase: GetEditProfileUseCaseProtocol = GetEditProfileUseCase()
    ) {
        self.newsRepository = newsRepository
        self.profileUseCase = profileUseCase
    }

    func execute() async throws -> [Article] {
        let (profile, _, _) = try await profileUseCase.execute()

        var terms: [String] = []

        for allergy in profile.allergies {
            terms.append("\(allergy.name) allergie")
        }

        for disease in profile.diseases {
            terms.append("\(disease.name) disease")
        }

        guard !terms.isEmpty else { return [] }

        let query = "(\(terms.joined(separator: " OR ")))"

        let articles = try await newsRepository.searchArticles(query: query)
        return Array(articles.prefix(10))
    }
}
