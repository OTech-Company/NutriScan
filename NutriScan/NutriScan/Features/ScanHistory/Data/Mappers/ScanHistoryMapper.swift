//
//  ScanHistoryMapper.swift
//  NutriScan
//

import Foundation

extension ScanHistoryEntity {
    
    init(dto: ScanHistoryItemDTO) {
        self.id = dto.scanId ?? UUID().uuidString
        self.productName = dto.productName ?? LocalizationKeys.Calories.unknownProduct.localized
        self.imageUrl = dto.imageUrl ?? ""
        self.calories = dto.calories ?? 0.0
        self.scannedAt = dto.scannedAt ?? ""
        self.scanStatus = ScanStatus(rawValue: dto.status ?? "") ?? .processing

        if scanStatus == .failed {
            self.status = .failed
            return
        }
        
        let verdictRaw = dto.verdict?.uppercased() ?? "CAUTION"
        switch verdictRaw {
        case "SAFE":
            self.status = .safe
        case "UNSAFE":
            self.status = .unsafe
        default:
            self.status = .caution
        }
    }
}
