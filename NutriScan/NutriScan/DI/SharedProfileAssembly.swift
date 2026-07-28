//
//  SharedProfileAssembly.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//
import Foundation

struct SharedProfileAssembly: Assembly {
    func assemble(container: DIContainer) {
        // 1. Register the State Container (This acts essentially as a singleton store)
        container.register(type: SharedProfileStore.self, component: SharedProfileStore())
        
        // 2. Register the Data Source (Assumes you created SharedProfileDataSource conforming to the protocol)
        // Adjust the init based on how your network service is injected
        container.register(
            type: SharedProfileDataSourceProtocol.self,
            component: SharedProfileDataSource()
        )
        
        // 3. Register the Repository
        container.register(
            type: SharedProfileRepositoryProtocol.self,
            component: SharedProfileRepository()
        )
        
        // 4. Register the Use Cases
        container.register(
            type: FetchAndCacheProfileUseCaseProtocol.self,
            component: FetchAndCacheProfileUseCase()
        )
        
        container.register(
            type: ObserveProfileUseCaseProtocol.self,
            component: ObserveProfileUseCase()
        )
    }
}
