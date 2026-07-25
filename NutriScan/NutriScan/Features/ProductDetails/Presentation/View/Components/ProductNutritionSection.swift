//
//  ProductNutritionSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import SwiftUI

struct ProductNutritionSection: View {
    let state: ProductNutritionUIState
    
    var body: some View {
        ViewThatFits {
            HStack(spacing: 8) {
                ForEach(state.nutritionFacts) { factState in
                    NutritionFactView(state: factState)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(state.nutritionFacts) { factState in
                        NutritionFactView(state: factState)
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}

#Preview {
    ProductNutritionSection(state: ProductDetailsUIState.mock.nutritionState)
        .padding()
}
