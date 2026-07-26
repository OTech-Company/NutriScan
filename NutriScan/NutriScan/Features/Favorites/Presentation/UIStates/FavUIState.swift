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
    
//    init(entity: ) {
//        return FavUIState(
//            image: entity.image,
//            title: entity.title,
//            calories: entity.calories,
//            condition: entity.condition
//        )
//    }
}

enum Condition: String {
    case Safe
    case Caution
}
