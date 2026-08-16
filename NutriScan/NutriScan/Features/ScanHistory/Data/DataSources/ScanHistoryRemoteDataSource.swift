//
//  ScanHistoryRemoteDataSource.swift
//  NutriScan
//

import Foundation

protocol ScanHistoryRemoteDataSourceProtocol {
    func getScanHistory(page: Int, size: Int) async throws -> ScanHistoryPaginatedResponseDTO
    func deleteScan(scanId: String) async throws
    func getSuggestions(query: String) async throws -> [String]
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

    func deleteScan(scanId: String) async throws {
        let endpoint = ScanHistoryEndpoint.deleteScan(scanId: scanId)
        let _: EmptyResponse = try await networkService.request(endpoint)
    }

    func getSuggestions(query: String) async throws -> [String] {
        let endpoint = ScanHistoryEndpoint.getSuggestions(query: query)
        return try await networkService.request(endpoint)
    }
}
