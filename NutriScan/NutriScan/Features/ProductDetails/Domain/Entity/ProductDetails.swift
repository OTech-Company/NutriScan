//
//  ProductDetails.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation

struct ProductDetails {
    let scanId: String
    let scannedAt: String
    let imageUrl: String
    let productName: String
    let verdict : String
    let summary: String
    let flagedIngredients: [ProductDetailsFlagedIngredient]
    let calories: Int
    let proteinGrams: Double
    let carbsGrams: Double
    let fatG: Double
    let fiberGrams: Double
    let sugarG: Double
    let sodiumMg: Double
    let isFavorite: Bool
}

struct ProductDetailsFlagedIngredient {
    let ingredient: String
    let reason: String
    let type: String
    let name: [String]
}

extension ProductDetails {
    init(from dto: ProductDetailsScanDTO) {
        self.scanId = dto.scanId
        self.scannedAt = dto.scannedAt ?? "No date"
        self.imageUrl = dto.imageUrl ?? "No Image"
        self.productName = dto.productName ?? "Unknown Product"
        self.verdict = dto.foodSafetyResponse?.verdict ?? "No verdict"
        self.summary = dto.foodSafetyResponse?.summary ?? "No summary"
        
        self.flagedIngredients = dto.foodSafetyResponse?.flaggedIngredients?.map {
            ProductDetailsFlagedIngredient(
                ingredient: $0.ingredient ?? "Unknown ingredient",
                reason: $0.reason ?? "No reason provided",
                type: $0.type ?? "Unknown type",
                name: $0.name ?? []
            )
        } ?? []
        
        self.calories = dto.nutritionFacts?.calories ?? 0
        self.proteinGrams = dto.nutritionFacts?.proteinGrams ?? 0
        self.carbsGrams = dto.nutritionFacts?.carbsGrams ?? 0
        self.fatG = dto.nutritionFacts?.fatG ?? 0
        self.fiberGrams = dto.nutritionFacts?.fiberGrams ?? 0
        self.sugarG = dto.nutritionFacts?.sugarG ?? 0
        self.sodiumMg = dto.nutritionFacts?.sodiumMg ?? 0
        self.isFavorite = dto.favorite ?? false
    }
}
