//
//  CaloriesAssembly.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct CaloriesAssembly: Assembly {
    func assemble(container: DIContainer) {

        let service = DailyTrackingServiceImpl()
        let repository: DailyTrackingRepo = DailyTrackingRepoImpl(service: service)
        container.register(type: DailyTrackingRepo.self, component: repository)

        container.register(
            type: GetTodayTrackingUseCase.self,
            component: GetTodayTrackingUseCase(repository: repository)
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
    }
}
