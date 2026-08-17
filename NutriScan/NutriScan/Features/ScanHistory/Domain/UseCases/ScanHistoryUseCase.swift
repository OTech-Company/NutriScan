//
//  ScanHistoryUseCase.swift
//  NutriScan
//

import Foundation

protocol ScanHistoryUseCaseProtocol {
    func getScanHistory(page: Int, size: Int) async throws -> (scans: [ScanHistoryEntity], totalPages: Int)
    func deleteScan(scanId: String) async throws
    func getSuggestions(query: String) async throws -> [String]
}

class ScanHistoryUseCase: ScanHistoryUseCaseProtocol {
    
    let repository: ScanHistoryRepositoryProtocol
    
    init(repository: ScanHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    func getScanHistory(page: Int, size: Int) async throws -> (scans: [ScanHistoryEntity], totalPages: Int) {
        return try await repository.getScanHistory(page: page, size: size)
    }

    func deleteScan(scanId: String) async throws {
        try await repository.deleteScan(scanId: scanId)
    }

    func getSuggestions(query: String) async throws -> [String] {
        return try await repository.getSuggestions(query: query)
    }
}
