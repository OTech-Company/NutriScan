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
        let dailyTrackingRemoteDataSource = DailyTrackingRemoteDataSource(
            networkService: networkService
        )
        let dailyTrackingRepository = DailyTrackingRepository(
            remoteDataSource: dailyTrackingRemoteDataSource,
            dayProvider: DIContainer.shared.resolve(type: DailyTrackingDayProviding.self)
        )
        let addMealUseCase: AddMealUseCaseProtocol = AddMealUseCase(
            repository: dailyTrackingRepository
        )
        return FavoritesViewModel(
            favoritesUseCase: useCase,
            addMealUseCase: addMealUseCase
        )
    }
}
