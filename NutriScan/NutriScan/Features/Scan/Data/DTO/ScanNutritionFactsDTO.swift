//
//  ScanNutritionFactsDTO.swift
//  NutriScan
//
//  Created by Osama Hosam on 25/07/2026.
//



struct ScanNutritionFactsDTO: Decodable {
    let calories: Int?
    let proteinGrams: Double?
    let carbsGrams: Double?
    let fatG: Double?
    let fiberGrams: Double?
    let sugarG: Double?
    let sodiumMg: Double?
}
