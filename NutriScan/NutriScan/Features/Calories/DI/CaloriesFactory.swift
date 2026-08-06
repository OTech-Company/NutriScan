//
//  CaloriesFactory.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

@MainActor
enum CaloriesFactory {

    static func makeCaloriesViewModel() -> CaloriesViewModel {
        let getTodayCaloriesTrackingUseCase = DIContainer.shared.resolve(type: GetTodayCaloriesTrackingUseCaseProtocol.self)
        let addMealUseCase = DIContainer.shared.resolve(type: AddCaloriesMealUseCaseProtocol.self)
        let deleteMealUseCase = DIContainer.shared.resolve(type: DeleteMealUseCaseProtocol.self)
        let updateMealUseCase = DIContainer.shared.resolve(type: UpdateMealUseCaseProtocol.self)
        let updateWaterUseCase = DIContainer.shared.resolve(type: UpdateWaterUseCaseProtocol.self)
        let caloriesActivityStore = DIContainer.shared.resolve(type: CaloriesActivityStore.self)
        let profileStore = DIContainer.shared.resolve(type: UserProfileStore.self)
        let caloriesActivitySyncCoordinator = DIContainer.shared.resolve(type: CaloriesActivitySyncCoordinator.self)

        return CaloriesViewModel(
            getTodayCaloriesTrackingUseCase: getTodayCaloriesTrackingUseCase,
            addMealUseCase: addMealUseCase,
            deleteMealUseCase: deleteMealUseCase,
            updateMealUseCase: updateMealUseCase,
            updateWaterUseCase: updateWaterUseCase,
            caloriesActivityStore: caloriesActivityStore,
            profileStore: profileStore,
            caloriesActivitySyncCoordinator: caloriesActivitySyncCoordinator
        )
    }
}
