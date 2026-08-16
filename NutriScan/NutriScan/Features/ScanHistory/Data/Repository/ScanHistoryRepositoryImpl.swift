//
//  ScanHistoryRepositoryImpl.swift
//  NutriScan
//

import Foundation

class ScanHistoryRepositoryImpl: ScanHistoryRepositoryProtocol {
    private let remoteDataSource: ScanHistoryRemoteDataSourceProtocol
    
    init(remoteDataSource: ScanHistoryRemoteDataSourceProtocol = ScanHistoryRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getScanHistory(page: Int, size: Int) async throws -> (scans: [ScanHistoryEntity], totalPages: Int) {
        let response = try await remoteDataSource.getScanHistory(page: page, size: size)
        let entities = response.content?.map { ScanHistoryEntity(dto: $0) } ?? []
        return (scans: entities, totalPages: response.totalPages ?? 0)
    }

    func deleteScan(scanId: String) async throws {
        try await remoteDataSource.deleteScan(scanId: scanId)
    }

    func getSuggestions(query: String) async throws -> [String] {
        return try await remoteDataSource.getSuggestions(query: query)
    }
}
