//
//  UnsafeIngredientCard.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import SwiftUI

struct UnsafeIngredientCard: View {
    let state: UnsafeIngredientUIState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("- \(state.name)")
                .font(Font.AppFont.textPrimary)
                .foregroundStyle(Color(light: Color.Teal.teal1000, dark: Color.Teal.teal500))
            
            Text(state.allergyMatch)
                .font(Font.AppFont.textCaption)
                .foregroundStyle(Color(light: .white, dark: Color.Teal.teal500))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(light: Color.Gray.gray400, dark: Color.Teal.teal1500))
                .clipShape(Capsule())
                
            Text(state.description)
                .font(Font.AppFont.textSecondary)
                .foregroundStyle(Color(light: Color.Gray.gray800, dark: Color.Teal.teal700))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(light: Color.Gray.gray100, dark: Color.Teal.teal1400))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    UnsafeIngredientCard(state: ProductDetailsUIState.mock.ingredientsState.unsafeIngredients[0])
        .padding()
}
