//
//  ScanFlaggedIngredientDTO.swift
//  NutriScan
//
//  Created by Osama Hosam on 25/07/2026.
//


struct ScanFlaggedIngredientDTO: Decodable {
    let ingredient: String?
    let reason: String?
    let type: String?
    let name: [String]?
}
