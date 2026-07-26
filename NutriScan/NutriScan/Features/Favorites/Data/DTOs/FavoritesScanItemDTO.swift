//
//  ScanItemDTO.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import Foundation

struct FavoritesScanItemDTO: Codable {
    let scanId: String?
    let imageUrl: String?
    let verdict: String? // "SAFE", "CAUTION", "UNSAFE" (maps to your Condition enum)
    let scannedAt: String?
    let productName: String?
    let calories: Double?
    let status: String?
}
