//
//  ScanHistoryRepositoryProtocol.swift
//  NutriScan
//

import Foundation

protocol ScanHistoryRepositoryProtocol {
    func getScanHistory(page: Int, size: Int) async throws -> (scans: [ScanHistoryEntity], totalPages: Int)
}
