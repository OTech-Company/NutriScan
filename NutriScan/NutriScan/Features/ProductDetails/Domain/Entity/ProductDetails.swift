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
    init(from scan: ScanDetail, imageData: Data? = nil) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"

        let scannedAtString: String
        if let date = scan.scannedAt {
            scannedAtString = displayFormatter.string(from: date)
        } else {
            scannedAtString = displayFormatter.string(from: Date())
        }

        self.scanId = scan.scanId
        self.scannedAt = scannedAtString
        self.imageUrl = scan.imageUrl ?? ""
        self.productName = scan.productName ?? "Unknown Product"
        self.verdict = scan.foodSafetyResponse?.verdict.rawValue.capitalized ?? "Unknown"
        self.summary = scan.foodSafetyResponse?.summary ?? "No summary"
        self.flagedIngredients = scan.foodSafetyResponse?.flaggedIngredients.map {
            ProductDetailsFlagedIngredient(
                ingredient: $0.ingredient,
                reason: $0.reason,
                type: $0.type.rawValue,
                name: $0.name
            )
        } ?? []
        self.calories = scan.nutritionFacts?.calories ?? 0
        self.proteinGrams = scan.nutritionFacts?.proteinGrams ?? 0
        self.carbsGrams = scan.nutritionFacts?.carbsGrams ?? 0
        self.fatG = scan.nutritionFacts?.fatG ?? 0
        self.fiberGrams = scan.nutritionFacts?.fiberGrams ?? 0
        self.sugarG = scan.nutritionFacts?.sugarG ?? 0
        self.sodiumMg = scan.nutritionFacts?.sodiumMg ?? 0
        self.isFavorite = false
    }

    init(from dto: ProductDetailsScanDTO) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"

        self.scanId = dto.scanId
        if let dateString = dto.scannedAt,
           let date = ISO8601DateFormatter().date(from: dateString) {
            self.scannedAt = displayFormatter.string(from: date)
        } else {
            self.scannedAt = dto.scannedAt ?? "No date"
        }
        self.imageUrl = dto.imageUrl ?? ""
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
