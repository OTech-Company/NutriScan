//
//  HomeAssembly.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

struct HomeAssembly: Assembly {
    func assemble(container: DIContainer) {
        // Register the Home ViewModel or any feature-specific use cases if needed.
        // Since HomeViewModel uses a default argument resolver, registering it
        // in the container allows for clean testability and explicit dependency graphs.
        container.register(
            type: HomeViewModel.self,
            component: HomeViewModel(
                scanHistoryUseCase: container.resolve(type: ScanHistoryUseCaseProtocol.self),
                observeProfileUseCase: container.resolve(type: ObserveProfileUseCaseProtocol.self)
            )
        )
    }
}
