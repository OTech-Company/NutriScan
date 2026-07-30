//
//  CaloriesAssembly.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct CaloriesAssembly: @preconcurrency Assembly {
    @MainActor func assemble(container: DIContainer) {

        let service = CaloriesTrackingServiceImpl()
        let repository: CaloriesTrackingRepo = CaloriesTrackingRepoImpl(service: service)
        container.register(type: CaloriesTrackingRepo.self, component: repository)

        let caloriesActivityStore = CaloriesActivityStore()
        container.register(type: CaloriesActivityStore.self, component: caloriesActivityStore)

        container.register(
            type: GetTodayCaloriesTrackingUseCase.self,
            component: GetTodayCaloriesTrackingUseCase(repository: repository)
        )
        container.register(
            type: GetCaloriesTrackingByDateUseCase.self,
            component: GetCaloriesTrackingByDateUseCase(repository: repository)
        )
        container.register(
            type: AddMealUseCase.self,
            component: AddMealUseCase(repository: repository)
        )
        container.register(
            type: UpdateMealUseCase.self,
            component: UpdateMealUseCase(repository: repository)
        )
        container.register(
            type: DeleteMealUseCase.self,
            component: DeleteMealUseCase(repository: repository)
        )
        container.register(
            type: UpdateWaterUseCase.self,
            component: UpdateWaterUseCase(repository: repository)
        )

        container.register(
            type: CaloriesActivitySyncCoordinator.self,
            component: CaloriesActivitySyncCoordinator(
                caloriesActivityStore: caloriesActivityStore,
                profileStore: container.resolve(type: UserProfileStore.self),
                getCaloriesTrackingByDateUseCase: GetCaloriesTrackingByDateUseCase(repository: repository),
                updateWaterUseCase: UpdateWaterUseCase(repository: repository),
                fetchHistoryUseCase: container.resolve(type: FetchStepsHistoryUseCase.self)
            )
        )
    }
}
