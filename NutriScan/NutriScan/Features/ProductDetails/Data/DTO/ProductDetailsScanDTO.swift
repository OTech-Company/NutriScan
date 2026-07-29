//
//  ProductDetailsScanDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation

struct ProductDetailsResponse : Decodable {
    let product : ProductDetailsScanDTO
}

struct ProductDetailsScanDTO: Decodable {
    let scanId: String
    let status: String
    let scannedAt: String?
    let imageUrl: String?
    let productName: String?
    let foodSafetyResponse: ProductDetailsFoodSafetyResponseDTO?
    let nutritionFacts: ProductDetailsNutritionFactsDTO?
    let favorite: Bool
}

struct ProductDetailsFoodSafetyResponseDTO: Decodable {
    let verdict: String?
    let flaggedIngredients: [ProductDetailsFlagedIngredientDTO]?
    let summary: String?
}

struct ProductDetailsFlagedIngredientDTO: Decodable {
    let ingredient: String?
    let reason: String?
    let type: String?
    let name: [String]?
}

struct ProductDetailsNutritionFactsDTO: Decodable {
    let calories: Int?
    let proteinGrams: Double?
    let carbsGrams: Double?
    let fatG: Double?
    let fiberGrams: Double?
    let sugarG: Double?
    let sodiumMg: Double?
}
