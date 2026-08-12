//
//  ProductDetailsScanDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation

struct ProductDetailsResponse: Decodable {
    let scanId: String?
    let status: String?
    let scannedAt: String?
    let imageUrl: String?
    let productName: String?
    let foodSafetyResponse: ProductDetailsFoodSafetyResponseDTO?
    let nutritionFacts: ProductDetailsNutritionFactsDTO?
    let favorite: Bool?

    enum CodingKeys: String, CodingKey {
        case scanId, status, scannedAt, imageUrl, productName
        case foodSafetyResponse, nutritionFacts, favorite
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scanId = try container.decodeIfPresent(String.self, forKey: .scanId)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        scannedAt = try container.decodeIfPresent(String.self, forKey: .scannedAt)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        productName = try container.decodeIfPresent(String.self, forKey: .productName)
        foodSafetyResponse = try container.decodeIfPresent(ProductDetailsFoodSafetyResponseDTO.self, forKey: .foodSafetyResponse)
        nutritionFacts = try container.decodeIfPresent(ProductDetailsNutritionFactsDTO.self, forKey: .nutritionFacts)
        favorite = try container.decodeIfPresent(Bool.self, forKey: .favorite)
    }
}

typealias ProductDetailsScanDTO = ProductDetailsResponse

struct ProductDetailsFoodSafetyResponseDTO: Decodable {
    let verdict: String?
    let flaggedIngredients: [ProductDetailsFlaggedIngredientDTO]?
    let summary: String?
}

struct ProductDetailsFlaggedIngredientDTO: Decodable {
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
