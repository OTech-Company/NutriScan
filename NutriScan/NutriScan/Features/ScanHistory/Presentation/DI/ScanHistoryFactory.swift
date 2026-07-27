//
//  ScanHistoryFactory.swift
//  NutriScan
//

import Foundation
import SwiftUI

enum ScanHistoryFactory {
    static func makeScanHistoryView() -> ScanHistoryView {
        ScanHistoryView(viewModel: makeScanHistoryViewModel())
    }
    
    static func makeScanHistoryViewModel(networkService: NetworkServiceProtocol = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)) -> ScanHistoryViewModel {
        let remoteDataSource = ScanHistoryRemoteDataSource(networkService: networkService)
        let repository = ScanHistoryRepositoryImpl(remoteDataSource: remoteDataSource)
        let useCase = ScanHistoryUseCase(repository: repository)
        return ScanHistoryViewModel(scanHistoryUseCase: useCase)
    }
}
