//
//  ProductDetails.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation

struct ProductDetails {
    let scanId: String
    let status: String
    let scannedAt: String
    let imageUrl: String
    let productName: String
    let verdict: String
    let summary: String
    let flaggedIngredients: [ProductDetailsFlaggedIngredient]
    let familyAlerts: [ProductDetailsFamilyAlert]
    let calories: Int
    let proteinGrams: Double
    let carbsGrams: Double
    let fatG: Double
    let fiberGrams: Double
    let sugarG: Double
    let sodiumMg: Double
    let isFavorite: Bool
}

struct ProductDetailsFlaggedIngredient {
    let ingredient: String
    let reason: String
    let type: String
    let name: [String]
}

struct ProductDetailsFamilyAlert {
    let targetProfile: String
    let severity: String
    let reason: String
}

extension ProductDetails {
    init(from scan: ScanDetail, imageData: Data? = nil) {
        self.scanId = scan.scanId
        self.status = scan.status.rawValue
        self.scannedAt = scan.scannedAt.map(Self.shortDateString) ?? Self.shortDateString(from: Date())
        self.imageUrl = scan.imageUrl ?? ""
        self.productName = scan.productName ?? "Unknown Product"
        self.verdict = scan.foodSafetyResponse?.verdict.rawValue.capitalized ?? "Unknown"
        self.summary = scan.foodSafetyResponse?.summary ?? "No summary"
        self.flaggedIngredients = scan.foodSafetyResponse?.flaggedIngredients.map {
            ProductDetailsFlaggedIngredient(
                ingredient: $0.ingredient,
                reason: $0.reason,
                type: $0.type.rawValue,
                name: $0.name
            )
        } ?? []
        self.familyAlerts = scan.foodSafetyResponse?.familyAlerts.map {
            ProductDetailsFamilyAlert(
                targetProfile: $0.targetProfile,
                severity: $0.severity,
                reason: $0.reason
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
        self.scanId = dto.scanId ?? ""
        self.status = dto.status ?? "Unknown"
        self.scannedAt = Self.shortDateString(from: dto.scannedAt)
        self.imageUrl = dto.imageUrl ?? ""
        self.productName = dto.productName ?? "Unknown Product"
        self.verdict = dto.foodSafetyResponse?.verdict ?? "No verdict"
        self.summary = dto.foodSafetyResponse?.summary ?? "No summary"
        
        self.flaggedIngredients = dto.foodSafetyResponse?.flaggedIngredients?.map {
            ProductDetailsFlaggedIngredient(
                ingredient: $0.ingredient ?? "Unknown ingredient",
                reason: $0.reason ?? "No reason provided",
                type: $0.type ?? "Unknown type",
                name: $0.name ?? []
            )
        } ?? []
        self.familyAlerts = dto.foodSafetyResponse?.familyAlerts?.map {
            ProductDetailsFamilyAlert(
                targetProfile: $0.targetProfile ?? "Unknown profile",
                severity: $0.severity ?? "UNKNOWN",
                reason: $0.reason ?? ""
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

    private static func shortDateString(from rawDate: String?) -> String {
        guard let rawDate else { return "No date" }
        guard let date = isoDate(from: rawDate) else { return rawDate }
        return shortDateString(from: date)
    }

    private static func shortDateString(from date: Date) -> String {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy-MM-dd"
        return displayFormatter.string(from: date)
    }

    private static func isoDate(from rawDate: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: rawDate) {
            return date
        }

        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: rawDate)
    }
}
