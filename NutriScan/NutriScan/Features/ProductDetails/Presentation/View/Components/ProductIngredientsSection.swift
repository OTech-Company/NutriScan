//
//  ProductIngredientsSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import SwiftUI

struct ProductIngredientsSection: View {
    let state: ProductIngredientsUIState

    private var leftIngredients: [UnsafeIngredientUIState] {
        state.unsafeIngredients.enumerated()
            .filter { $0.offset.isMultiple(of: 2) }
            .map(\.element)
    }

    private var rightIngredients: [UnsafeIngredientUIState] {
        state.unsafeIngredients.enumerated()
            .filter { !$0.offset.isMultiple(of: 2) }
            .map(\.element)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("\(LocalizationKeys.ProductDetails.whyIts.localized) \(state.safetyLevel.localizedTitle)?")
                .font(Font.AppFont.subtitle2)
                .foregroundStyle(
                    Color(
                        light: Color.Gray.gray1000,
                        dark: Color.Teal.teal500
                    )
                )
                .padding(.top, 8)

            HStack(alignment: .top, spacing: 8) {
                VStack(spacing: 8) {
                    ForEach(leftIngredients) { ingredientState in
                        UnsafeIngredientCard(state: ingredientState)
                    }
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 8) {
                    ForEach(rightIngredients) { ingredientState in
                        UnsafeIngredientCard(state: ingredientState)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    ProductIngredientsSection(
        state: ProductDetailsUIState.mock.ingredientsState
    )
    .padding()
}
