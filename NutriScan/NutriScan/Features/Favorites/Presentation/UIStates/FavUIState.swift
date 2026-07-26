//
//  FavUIState.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import Foundation

struct FavUIState {
    let id: String
    let image: String
    let title: String
    let calories: Double
    let condition: Condition
    
    
}

extension FavUIState {
    init(entity: FavoritesScanEntity) {
        self.id = entity.id
        self.title = entity.productName
        self.image = entity.imageUrl
        self.calories = entity.calories
        self.condition = entity.condition
    }
}
