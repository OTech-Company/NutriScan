//
//  ProfileSetupFlowFactory.swift
//  NutriScan
//

import Foundation

enum ProfileSetupFlowFactory {
    static func makeViewModel(networkService: NetworkServiceProtocol = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)) -> ProfileSetupFlowViewModel {
        let remoteDataSource = ProfileSetupRemoteDataSource(networkService: networkService)
        let repository = ProfileSetupRepository(remoteDataSource: remoteDataSource)
        let updateUseCase = ProfileSetupUpdateUseCase(repository: repository)
        let fetchOptionsUseCase = FetchProfileSetupOptionsUseCase(repository: repository)
        return ProfileSetupFlowViewModel(
            updateProfileUseCase: updateUseCase,
            fetchOptionsUseCase: fetchOptionsUseCase
        )
    }
}
