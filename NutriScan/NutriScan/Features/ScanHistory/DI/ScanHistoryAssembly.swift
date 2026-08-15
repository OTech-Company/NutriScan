//
//  ScanHistoryAssembly.swift
//  NutriScan
//

import Foundation

struct ScanHistoryAssembly: Assembly {
    func assemble(container: DIContainer) {
        let networkService = container.resolve(type: NetworkServiceProtocol.self)
        let remoteDataSource: ScanHistoryRemoteDataSourceProtocol = ScanHistoryRemoteDataSource(networkService: networkService)
        let repository: ScanHistoryRepositoryProtocol = ScanHistoryRepositoryImpl(remoteDataSource: remoteDataSource)

        container.register(
            type: ScanHistoryRepositoryProtocol.self,
            component: repository
        )
        container.register(
            type: ScanHistoryUseCaseProtocol.self,
            component: ScanHistoryUseCase(repository: repository)
        )
    }
}
