//
//  CaloriesHistoryAssembly.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import Foundation

struct CaloriesHistoryAssembly: Assembly {
    func assemble(container: DIContainer) {
        let remoteDataSource = CaloriesHistoryRemoteDataSource(
            networkService: container.resolve(type: NetworkServiceProtocol.self)
        )
        let repository: CaloriesHistoryRepositoryProtocol = CaloriesHistoryRepositoryImpl(
            remoteDataSource: remoteDataSource
        )

        container.register(type: CaloriesHistoryRepositoryProtocol.self, component: repository)
        container.register(
            type: GetCaloriesHistoryPageUseCaseProtocol.self,
            component: GetCaloriesHistoryPageUseCase(repository: repository)
        )
        container.register(
            type: GetCaloriesHistoryByDateUseCaseProtocol.self,
            component: GetCaloriesHistoryByDateUseCase(repository: repository)
        )
    }
}
