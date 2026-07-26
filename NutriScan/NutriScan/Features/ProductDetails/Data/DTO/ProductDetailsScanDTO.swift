//
//  ProductDetailsScanDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation
import Playgrounds

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
    let proteinGrams: Int?
    let carbsGrams: Int?
    let fatG: Int?
    let fiberGrams: Int?
    let sugarG: Int?
    let sodiumMg: Int?
}


#Playground {
    Task {
        do {
            let response: ProductDetailsResponse = try await NetworkService.shared.request(ProductDetailsEndPoint.getProductDetails(scanId: "3fa85f64-5717-4562-b3fc-2c963f66afa6"))
            print(response.product)
        } catch {
            print("Error: \(error)")
        }
    }
}
