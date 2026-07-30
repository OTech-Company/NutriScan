//
//  ScanHistoryPaginatedResponseDTO.swift
//  NutriScan
//

import Foundation

struct ScanHistoryPaginatedResponseDTO: Codable {
    let totalElements: Int?
    let totalPages: Int?
    let numberOfElements: Int?
    let size: Int?
    let number: Int?
    let content: [ScanHistoryItemDTO]?
}
