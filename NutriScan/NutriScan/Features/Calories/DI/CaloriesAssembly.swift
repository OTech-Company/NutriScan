//
//  CaloriesAssembly.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct CaloriesAssembly: @preconcurrency Assembly {
    @MainActor func assemble(container: DIContainer) {

        let service = DailyTrackingServiceImpl()
        let repository: DailyTrackingRepo = DailyTrackingRepoImpl(service: service)
        container.register(type: DailyTrackingRepo.self, component: repository)

        let activityStore = DailyActivityStore()
        container.register(type: DailyActivityStore.self, component: activityStore)

        container.register(
            type: GetTodayTrackingUseCase.self,
            component: GetTodayTrackingUseCase(repository: repository)
        )
        container.register(
            type: GetTrackingByDateUseCase.self,
            component: GetTrackingByDateUseCase(repository: repository)
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
            type: DailyActivitySyncCoordinator.self,
            component: DailyActivitySyncCoordinator(
                activityStore: activityStore,
                profileStore: container.resolve(type: UserProfileStore.self),
                getTrackingByDateUseCase: GetTrackingByDateUseCase(repository: repository),
                updateTrackingUseCase: UpdateWaterUseCase(repository: repository),
                fetchHistoryUseCase: container.resolve(type: FetchStepsHistoryUseCase.self)
            )
        )
    }
}
