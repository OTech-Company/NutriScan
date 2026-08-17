//
//  ScanHistoryRepositoryProtocol.swift
//  NutriScan
//

import Foundation

protocol ScanHistoryRepositoryProtocol {
    func getScanHistory(page: Int, size: Int) async throws -> (scans: [ScanHistoryEntity], totalPages: Int)
    func deleteScan(scanId: String) async throws
    func getSuggestions(query: String) async throws -> [String]
}
