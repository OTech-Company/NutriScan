//
//  ProductDetailsUIState.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import Foundation

struct ProductDetailsUIState {
    var isFavorite: Bool
    let headerState: ProductHeaderUIState
    let safetyState: ProductSafetyUIState
    let ingredientsState: ProductIngredientsUIState
    let nutritionState: ProductNutritionUIState
    
    static let mock = ProductDetailsUIState(
        isFavorite: false,
        headerState: ProductHeaderUIState(
            imageUrl: "https://www.heritagefoods.in/blog/wp-content/uploads/2020/12/shutterstock_539045662.jpg",
            productName: "Milk Product\nName",
            scannedAt: "2026-07-13"
        ),
        safetyState: ProductSafetyUIState(
            safetyLevel: .unsafe,
            safetyDescription: "Contains hazelnuts and milk, both of which match allergies on your profile."
        ),
        ingredientsState: ProductIngredientsUIState(
            safetyLevel: .unsafe,
            unsafeIngredients: [
                .init(name: "Hazelnuts", allergyMatch: "Tree Nuts Allergy", description: "Matches allergy in your profile"),
                .init(name: "Skimmed Milk Powder", allergyMatch: "Lactose Intolerance", description: "Contains milk ingredient")
            ]
        ),
        nutritionState: ProductNutritionUIState(
            nutritionFacts: [
                .init(title: "Calories", value: "80 kcal"),
                .init(title: "Serving", value: "15 g"),
                .init(title: "Sugar", value: "8.5 g"),
                .init(title: "Fat", value: "4.5 g"),
                .init(title: "Sat. Fat", value: "1.6 g")
            ]
        )
    )
}

extension ProductDetailsUIState {
    init(from details: ProductDetails) {
        // Parse the safety level string to Enum
        let parsedSafety = SafetyLevel(rawValue: details.verdict.lowercased().capitalized) ?? .unsafe
        
        self.isFavorite = details.isFavorite
        self.headerState = ProductHeaderUIState(
            imageUrl: details.imageUrl,
            productName: details.productName,
            scannedAt: details.scannedAt
        )
        
        self.safetyState = ProductSafetyUIState(
            safetyLevel: parsedSafety,
            safetyDescription: details.summary
        )
        
        self.ingredientsState = ProductIngredientsUIState(
            safetyLevel: parsedSafety,
            unsafeIngredients: details.flagedIngredients.map {
                UnsafeIngredientUIState(
                    name: $0.ingredient,
                    allergyMatch: $0.reason,
                    description: $0.type
                )
            }
        )
        
        self.nutritionState = ProductNutritionUIState(
            nutritionFacts: [
                NutritionFactUIState(title: "Calories", value: "\(details.calories) kcal"),
                NutritionFactUIState(title: "Protein", value: "\(details.proteinGrams) g"),
                NutritionFactUIState(title: "Carbs", value: "\(details.carbsGrams) g"),
                NutritionFactUIState(title: "Fat", value: "\(details.fatG) g"),
                NutritionFactUIState(title: "Sugar", value: "\(details.sugarG) g")
            ]
        )
    }
}
