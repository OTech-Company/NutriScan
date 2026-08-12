//
//  ProductDetailsUIState.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import Foundation

struct ProductDetailsUIState {
    let status: String
    var isFavorite: Bool
    let headerState: ProductHeaderUIState
    let safetyState: ProductSafetyUIState
    let ingredientsState: ProductIngredientsUIState
    let nutritionState: ProductNutritionUIState
    
    static let mock = ProductDetailsUIState(
        status: "COMPLETED",
        isFavorite: false,
        headerState: ProductHeaderUIState(
            imageUrl: "https://res.cloudinary.com/k7gmlc9n/image/upload/v1786544831/nutriscan/rnmnlbkj1u8ucyiihnri.jpg",
            productName: "Frozen Caramel Toffee Ice Cream Cake",
            scannedAt: "2026-08-12"
        ),
        safetyState: ProductSafetyUIState(
            safetyLevel: .unsafe,
            safetyDescription: "This dessert is high in sugar and fat, making it inappropriate for your declared chronic conditions, particularly diabetes and heart-related issues."
        ),
        ingredientsState: ProductIngredientsUIState(
            safetyLevel: .unsafe,
            unsafeIngredients: [
                .init(
                    ingredient: "Caramel sauce",
                    reason: "This is a concentrated source of added sugar, which can negatively impact blood glucose levels.",
                    type: "CHRONIC_CONDITION",
                    name: ["Diabetes"]
                ),
                .init(
                    ingredient: "Ice cream",
                    reason: "Ice cream is often high in saturated fats and sodium, which should be limited for heart health and blood pressure management.",
                    type: "CHRONIC_CONDITION",
                    name: ["Heart Failure, Hypertension"]
                ),
                .init(
                    ingredient: "Toffee/Chocolate topping",
                    reason: "These components are high in refined sugars, which are inappropriate for managing diabetes.",
                    type: "CHRONIC_CONDITION",
                    name: ["Diabetes"]
                )
            ]
        ),
        nutritionState: ProductNutritionUIState(
            nutritionFacts: [
                .init(title: "Calories", value: "450 kcal"),
                .init(title: "Protein", value: "5 g"),
                .init(title: "Carbs", value: "55 g"),
                .init(title: "Fat", value: "22 g"),
                .init(title: "Sugar", value: "40 g"),
                .init(title: "Fiber", value: "1 g"),
                .init(title: "Sodium", value: "180 mg")
            ]
        )
    )
}

extension ProductDetailsUIState {
    init(from details: ProductDetails) {
        // Parse the safety level string to Enum
        let parsedSafety = SafetyLevel(rawValue: details.verdict.lowercased().capitalized) ?? .unsafe
        
        self.status = details.status
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
            unsafeIngredients: details.flaggedIngredients.map {
                UnsafeIngredientUIState(
                    ingredient: $0.ingredient,
                    reason: $0.reason,
                    type: $0.type,
                    name: $0.name
                )
            }
        )
        
        self.nutritionState = ProductNutritionUIState(
            nutritionFacts: [
                NutritionFactUIState(title: "Calories", value: "\(details.calories) kcal"),
                NutritionFactUIState(title: "Protein", value: Self.formattedGrams(details.proteinGrams)),
                NutritionFactUIState(title: "Carbs", value: Self.formattedGrams(details.carbsGrams)),
                NutritionFactUIState(title: "Fat", value: Self.formattedGrams(details.fatG)),
                NutritionFactUIState(title: "Sugar", value: Self.formattedGrams(details.sugarG)),
                NutritionFactUIState(title: "Fiber", value: Self.formattedGrams(details.fiberGrams)),
                NutritionFactUIState(title: "Sodium", value: "\(Self.formattedNumber(details.sodiumMg)) mg")
            ]
        )
    }

    private static func formattedGrams(_ value: Double) -> String {
        "\(formattedNumber(value)) g"
    }

    private static func formattedNumber(_ value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        }
        return String(format: "%.1f", value)
    }
}
