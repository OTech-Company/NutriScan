//
//  NutritionFactView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import SwiftUI

struct NutritionFactView: View {
    let state: NutritionFactUIState
    
    var body: some View {
        VStack(spacing: 4) {
            Text(state.title)
                .font(Font.AppFont.textCaption)
                .foregroundStyle(Color(light: Color.Gray.gray800, dark: Color.Teal.teal200))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(minWidth: 62)
                .padding(.vertical, 6)
                .background(Color(light: Color.Gray.gray100, dark: Color.Teal.teal1400))
                .clipShape(Capsule())
                
            Text(state.value)
                .font(Font.AppFont.textCaption)
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(minWidth: 62)
                .padding(.vertical, 6)
                .background(Color.Teal.teal1000)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    NutritionFactView(state: ProductDetailsUIState.mock.nutritionState.nutritionFacts[0])
        .padding()
}
