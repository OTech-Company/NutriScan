//
//  FavoritesMapper.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import Foundation

extension FavoritesScanEntity {
    
    init(dto: FavoritesScanItemDTO) {
        self.id = dto.scanId ?? UUID().uuidString
        self.productName = dto.productName ?? "UnKnown Product"
        self.imageUrl = dto.imageUrl ?? ""
        self.calories = dto.calories ?? 0.0
        
        let verdict = dto.verdict?.lowercased() ?? "caution"
        let firstletterUppercase = verdict.prefix(1).uppercased() + verdict.dropFirst()
        
        self.condition = Condition(rawValue: firstletterUppercase) ?? .Caution
    }
}
