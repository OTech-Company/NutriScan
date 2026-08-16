//
//  StepTrackerAssembly.swift
//  NutriScan
//

import Foundation

struct StepTrackerAssembly: Assembly {
    @MainActor func assemble(container: DIContainer) {
        let healthKitSource = HealthKitStepDataSource()
        let repository = StepRepositoryImpl(healthKitSource: healthKitSource)

        container.register(
            type: HealthKitStepDataSource.self,
            component: healthKitSource
        )

        // Register step tracker use cases
        container.register(
            type: ObserveDailyStepsUseCase.self,
            component: ObserveDailyStepsUseCase(repository: repository)
        )
        container.register(
            type: RequestStepAuthorizationUseCase.self,
            component: RequestStepAuthorizationUseCase(repository: repository)
        )
        container.register(
            type: FetchStepsHistoryUseCase.self,
            component: FetchStepsHistoryUseCase(repository: repository)
        )

        // Register user profile service using the shared observer use case
        container.register(
            type: UserProfileService.self,
            component: UserProfileService(
                observeProfileUseCase: container.resolve(
                    type: ObserveProfileUseCaseProtocol.self)
            )
        )
    }
}
