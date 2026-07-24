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
        ScanAssembly(),
        StepTrackerAssembly(),
        RAGAssembly()
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
        container.register(type: ScanRepository.self, component: repository)
        container.register(
            type: UploadScanUseCase.self,
            component: UploadScanUseCaseImpl(repository: repository)
        )
        container.register(
            type: ObserveScanResultUseCase.self,
            component: ObserveScanResultUseCaseImpl(repository: repository)
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
    func assemble(container: DIContainer) {
        let repository = StepRepositoryImpl()
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
    }
}
