//
//  ProfileSetupFlowFactory.swift
//  NutriScan
//

import Foundation

enum ProfileSetupFlowFactory {
    static func makeViewModel(networkService: NetworkServiceProtocol = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)) -> ProfileSetupFlowViewModel {
        let repository = ProfileSetupRepository(networkService: networkService)
        let updateUseCase = ProfileSetupUpdateUseCase(repository: repository)
        let fetchOptionsUseCase = FetchProfileSetupOptionsUseCase(repository: repository)
        return ProfileSetupFlowViewModel(
            updateProfileUseCase: updateUseCase,
            fetchOptionsUseCase: fetchOptionsUseCase
        )
    }
}
