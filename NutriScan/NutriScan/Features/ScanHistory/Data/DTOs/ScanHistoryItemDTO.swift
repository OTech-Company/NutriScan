//
//  ScanHistoryItemDTO.swift
//  NutriScan
//

import Foundation

struct ScanHistoryItemDTO: Codable {
    let scanId: String?
    let imageUrl: String?
    let verdict: String?
    let scannedAt: String?
    let productName: String?
    let calories: Double?
    let status: String?
}
