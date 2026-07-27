//
//  PaginatedScanResponseDTO.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import Foundation

struct FavoritesPaginatedScanResponseDTO: Codable {
    let totalElements: Int?
    let totalPages: Int?
    let numberOfElements: Int?
    let size: Int?
    let number: Int?
    let content: [FavoritesScanItemDTO]?
}
