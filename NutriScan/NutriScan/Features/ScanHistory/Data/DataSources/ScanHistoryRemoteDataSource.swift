//
//  ScanHistoryRemoteDataSource.swift
//  NutriScan
//

import Foundation

protocol ScanHistoryRemoteDataSourceProtocol {
    func getScanHistory(page: Int, size: Int) async throws -> ScanHistoryPaginatedResponseDTO
}

class ScanHistoryRemoteDataSource: ScanHistoryRemoteDataSourceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func getScanHistory(page: Int, size: Int) async throws -> ScanHistoryPaginatedResponseDTO {
        let endpoint = ScanHistoryEndpoint.getScanHistory(page: page, size: size)
        return try await networkService.request(endpoint)
    }
}
