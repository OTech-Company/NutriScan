import SwiftUI

struct NewsAssembly: Assembly {
    func assemble(container: DIContainer) {
        let networkService = container.resolve(type: NetworkServiceProtocol.self)
        let remoteDataSource: NewsRemoteDataSourceProtocol = NewsRemoteDataSource(
            networkService: networkService
        )
        let repository: NewsRepositoryProtocol = NewsRepository(
            remoteDataSource: remoteDataSource
        )
        let profileProvider: NewsProfileProviding = NewsProfileAdapter(
            fetchAndCacheProfileUseCase: container.resolve(
                type: FetchAndCacheProfileUseCaseProtocol.self
            ),
            observeProfileUseCase: container.resolve(
                type: ObserveProfileUseCaseProtocol.self
            )
        )
        let interestsUseCase: FetchNewsInterestsUseCaseProtocol = FetchNewsInterestsUseCase(
            profileProvider: profileProvider
        )
        let feedUseCase: FetchNewsFeedUseCaseProtocol = FetchNewsFeedUseCase(
            repository: repository
        )

        container.register(type: NewsRepositoryProtocol.self, component: repository)
        container.register(type: NewsProfileProviding.self, component: profileProvider)
        container.register(
            type: FetchTopHeadlinesUseCaseProtocol.self,
            component: FetchTopHeadlinesUseCase(repository: repository)
        )
        container.register(type: FetchNewsInterestsUseCaseProtocol.self, component: interestsUseCase)
        container.register(type: FetchNewsFeedUseCaseProtocol.self, component: feedUseCase)
        container.register(
            type: NewsViewModelFactoryProtocol.self,
            component: NewsViewModelFactory(
                fetchNewsInterestsUseCase: interestsUseCase,
                fetchNewsFeedUseCase: feedUseCase
            )
        )
    }
}

@MainActor
protocol NewsViewModelFactoryProtocol {
    func makeViewModel() -> NewsViewModel
}

struct NewsViewModelFactory: NewsViewModelFactoryProtocol {
    let fetchNewsInterestsUseCase: FetchNewsInterestsUseCaseProtocol
    let fetchNewsFeedUseCase: FetchNewsFeedUseCaseProtocol

    @MainActor
    func makeViewModel() -> NewsViewModel {
        NewsViewModel(
            fetchNewsInterestsUseCase: fetchNewsInterestsUseCase,
            fetchNewsFeedUseCase: fetchNewsFeedUseCase
        )
    }
}

enum NewsFactory {
    @MainActor
    static func makeNewsView() -> some View {
        let factory = DIContainer.shared.resolve(type: NewsViewModelFactoryProtocol.self)
        return NewsView(viewModel: factory.makeViewModel())
    }
}
