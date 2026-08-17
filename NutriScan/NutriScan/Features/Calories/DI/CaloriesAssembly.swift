//
//  CaloriesAssembly.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct CaloriesAssembly: Assembly {
    @MainActor func assemble(container: DIContainer) {

        let dayProvider = container.resolve(type: DailyTrackingDayProviding.self)
        let service = CaloriesTrackingServiceImpl()
        let repository: CaloriesTrackingRepo = CaloriesTrackingRepoImpl(
            service: service,
            dayProvider: dayProvider
        )
        container.register(type: CaloriesTrackingRepo.self, component: repository)

        let caloriesActivityStore = CaloriesActivityStore()
        container.register(type: CaloriesActivityStore.self, component: caloriesActivityStore)

        let getTodayCaloriesTrackingUseCase: GetTodayCaloriesTrackingUseCaseProtocol = GetTodayCaloriesTrackingUseCase(repository: repository)
        let getCaloriesTrackingByDateUseCase: GetCaloriesTrackingByDateUseCaseProtocol = GetCaloriesTrackingByDateUseCase(repository: repository)
        let addCaloriesMealUseCase: AddCaloriesMealUseCaseProtocol = AddCaloriesMealUseCase(repository: repository)
        let updateMealUseCase: UpdateMealUseCaseProtocol = UpdateMealUseCase(repository: repository)
        let deleteMealUseCase: DeleteMealUseCaseProtocol = DeleteMealUseCase(repository: repository)
        let updateWaterUseCase: UpdateWaterUseCaseProtocol = UpdateWaterUseCase(repository: repository)

        container.register(
            type: GetTodayCaloriesTrackingUseCaseProtocol.self,
            component: getTodayCaloriesTrackingUseCase
        )
        container.register(
            type: GetCaloriesTrackingByDateUseCaseProtocol.self,
            component: getCaloriesTrackingByDateUseCase
        )
        container.register(
            type: AddCaloriesMealUseCaseProtocol.self,
            component: addCaloriesMealUseCase
        )
        container.register(
            type: UpdateMealUseCaseProtocol.self,
            component: updateMealUseCase
        )
        container.register(
            type: DeleteMealUseCaseProtocol.self,
            component: deleteMealUseCase
        )
        container.register(
            type: UpdateWaterUseCaseProtocol.self,
            component: updateWaterUseCase
        )

        container.register(
            type: CaloriesActivitySyncCoordinator.self,
            component: CaloriesActivitySyncCoordinator(
                caloriesActivityStore: caloriesActivityStore,
                profileStore: container.resolve(type: UserProfileStore.self),
                getCaloriesTrackingByDateUseCase: getCaloriesTrackingByDateUseCase,
                updateWaterUseCase: updateWaterUseCase,
                fetchHistoryUseCase: container.resolve(type: FetchStepsHistoryUseCase.self),
                dayProvider: dayProvider
            )
        )
    }
}
