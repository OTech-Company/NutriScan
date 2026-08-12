//
//  ScanHistoryEntity.swift
//  NutriScan
//

import Foundation

struct ScanHistoryEntity: Identifiable, Equatable {
    let id: String
    let productName: String
    let imageUrl: String
    let calories: Double
    let scannedAt: String
    let status: StatusType
    let scanStatus: ScanStatus
}
