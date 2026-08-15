//
//  UnsafeIngredientUIState.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import Foundation

struct UnsafeIngredientUIState: Identifiable {
    let id = UUID()
    let ingredient: String
    let reason: String
    let type: String
    let name: [String]

    var matchText: String {
        name.isEmpty ? type : name.joined(separator: ", ")
    }
}
