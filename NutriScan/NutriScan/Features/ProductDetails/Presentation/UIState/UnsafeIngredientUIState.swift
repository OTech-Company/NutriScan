//
//  UnsafeIngredientUIState.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import Foundation

struct UnsafeIngredientUIState: Identifiable {
    let id = UUID()
    let name: String
    let allergyMatch: String
    let description: String
}
