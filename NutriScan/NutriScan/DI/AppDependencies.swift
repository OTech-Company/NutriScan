//
//  AppDependencies.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//
import Foundation

struct AppDependencies {
    
    static func setup() {
        let container = DIContainer.shared
        
        // 1. Core Services (Register your temporary token provider here)
        container.register(type: TokenProviding.self, component: HardcodedTokenProvider())
        container.register(type: NetworkServiceProtocol.self, component: NetworkService(tokenProvider: container.resolve(type: TokenProviding.self)))
        
        // 2. Profile Feature
        container.register(
            type: ProfileRepositoryProtocol.self,
            component: ProfileRepository(networkService: container.resolve(type: NetworkServiceProtocol.self))
        )
        
        container.register(
            type: ProfileUseCaseProtocol.self,
            component: ProfileUseCase(repository: container.resolve(type: ProfileRepositoryProtocol.self))
        )
        
        // Teammates can add their features below:
        // container.register(type: HomeUseCaseProtocol.self, component: HomeUseCase(...))
    }
}
