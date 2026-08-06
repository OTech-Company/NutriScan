import Foundation
import SwiftUI

enum FavoritesFactory {
    static func makeFavoritesView() -> FavoritesView {
        FavoritesView(viewModel: makeFavoritesViewModel())
    }
    
    static func makeFavoritesViewModel(networkService: NetworkServiceProtocol = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)) -> FavoritesViewModel {
        let remoteDataSource = FavoritesRemoteDataSource(networkService: networkService)
        let repository = FavoritesRepository(remoteDataSource: remoteDataSource)
        let useCase = FavoritesUseCase(favoritesRepository: repository)
        let addMealUseCase: AddMealUseCaseProtocol = AddMealUseCase()
        return FavoritesViewModel(
            favoritesUseCase: useCase,
            addMealUseCase: addMealUseCase
        )
    }
}
