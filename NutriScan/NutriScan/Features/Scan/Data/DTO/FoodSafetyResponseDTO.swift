//
//  FoodSafetyResponseDTO.swift
//  NutriScan
//
//  Created by Osama Hosam on 25/07/2026.
//



struct FoodSafetyResponseDTO: Decodable {
    let verdict: String?
    let flaggedIngredients: [ScanFlaggedIngredientDTO]?
    let summary: String?
}