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

        // 1. Core Services
        container.register(type: NetworkServiceProtocol.self, component: NetworkService())

        // 2. Profile Feature
        container.register(
            type: ProfileRepositoryProtocol.self,
            component: ProfileRepository(networkService: container.resolve(type: NetworkServiceProtocol.self))
        )

        container.register(
            type: GetProfileDataUseCaseProtocol.self,
            component: GetProfileDataUseCase(repository: container.resolve(type: ProfileRepositoryProtocol.self))
        )

        container.register(
            type: UpdateProfileUseCaseProtocol.self,
            component: UpdateProfileUseCase(repository: container.resolve(type: ProfileRepositoryProtocol.self))
        )

        // Teammates can add their features below:
        // container.register(type: HomeUseCaseProtocol.self, component: HomeUseCase(...))
    }
}
