//
//  ProductSheetView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import SwiftUI

struct ProductSheetView: View {
    let state: ProductDetailsUIState
    
    init(state: ProductDetailsUIState = .mock) {
        self.state = state
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ProductHeaderSection(state: state.headerState)
                ProductSafetySection(state: state.safetyState)
                ProductIngredientsSection(state: state.ingredientsState)
                ProductNutritionSection(state: state.nutritionState)
                Spacer(minLength: 24)
            }
            .padding(.horizontal, 22)
            .padding(.top, 24)
            .padding(.bottom, 48) // Safe area compensation
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(Color(light: .white, dark: Color.Teal.teal1600))
                .clipShape(
                    .rect(
                        topLeadingRadius: 24,
                        topTrailingRadius: 24
                    )
                )
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    VStack(alignment: .center) {
        ProductSheetView()
    }
    .background(Color.black)
}
