//
//  AppDependencies.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//
//  Composition root: runs every feature's Assembly in dependency order.
//  Adding a new feature means adding one line here, not editing
//  registration logic that belongs to another feature.
//
import Foundation

struct AppDependencies {

    /// Ordered so Core (shared services) registers before any feature
    /// that depends on it (e.g. NetworkServiceProtocol before ProfileAssembly).
    private static let assemblies: [Assembly] = [
        CoreAssembly(),
        ProfileAssembly(),
        EditProfileAssembly(),
        ScanAssembly(),
        StepTrackerAssembly(),
        RAGAssembly(),
        SettingsAssembly()
        // Teammates: add your feature's Assembly here, e.g.
        // HomeAssembly(),
        // AuthAssembly(),
    ]

    static func setup() {
        let container = DIContainer.shared
        assemblies.forEach { $0.assemble(container: container) }
    }
}

// MARK: - Inline Assemblies (to avoid pbxproj conflicts)


struct ScanAssembly: Assembly {
    func assemble(container: DIContainer) {
        let repository = ScanRepositoryImpl()
        container.register(
            type: FetchScansUseCase.self,
            component: FetchScansUseCaseImpl(repository: repository)
        )
        container.register(
            type: SubmitScanImageUseCase.self,
            component: SubmitScanImageUseCaseImpl(repository: repository)
        )
        container.register(
            type: FetchScanDetailUseCase.self,
            component: FetchScanDetailUseCaseImpl(repository: repository)
        )
    }
}

struct RAGAssembly: Assembly {
    func assemble(container: DIContainer) {
        container.register(
            type: QueryRAGUseCase.self,
            component: QueryRAGUseCaseImpl(repository: RAGRepositoryImpl())
        )
    }
}

struct StepTrackerAssembly: Assembly {
    @MainActor func assemble(container: DIContainer) {
        let repository = StepRepositoryImpl()
        
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
        
        // Register user profile service for height/weight
        container.register(
            type: UserProfileService.self,
            component: UserProfileService(
                getProfileUseCase: container.resolve(type: GetEditProfileUseCaseProtocol.self)
            )
        )
    }
}
