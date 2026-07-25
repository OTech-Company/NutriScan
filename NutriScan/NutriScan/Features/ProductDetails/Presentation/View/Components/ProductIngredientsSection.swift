//
//  ProductIngredientsSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import SwiftUI

struct ProductIngredientsSection: View {
    let state: ProductIngredientsUIState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Why It's \(state.safetyLevel.rawValue)?")
                .font(Font.AppFont.subtitle2)
                .foregroundStyle(Color(light: Color.Gray.gray1000, dark: Color.Teal.teal500))
                .padding(.top, 8)
            
            HStack(alignment: .top, spacing: 16) {
                ForEach(state.unsafeIngredients) { ingredientState in
                    UnsafeIngredientCard(state: ingredientState)
                }
            }
        }
    }
}

#Preview {
    ProductIngredientsSection(state: ProductDetailsUIState.mock.ingredientsState)
        .padding()
}
