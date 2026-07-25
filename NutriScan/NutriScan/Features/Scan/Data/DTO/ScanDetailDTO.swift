//
//  ScanDetailDTO.swift
//  NutriScan
//
//  Created by Osama Hosam on 25/07/2026.
//


struct ScanDetailDTO: Decodable {
    let scanId: String
    let status: String
    let scannedAt: String?
    let imageUrl: String?
    let foodSafetyResponse: FoodSafetyResponseDTO?
    let nutritionFacts: ScanNutritionFactsDTO?
}