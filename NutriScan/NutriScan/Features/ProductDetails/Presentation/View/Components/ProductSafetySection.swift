//
//  ProductSafetySection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import SwiftUI

struct ProductSafetySection: View {
    let state: ProductSafetyUIState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SafetyLevelText(safetyLevel: state.safetyLevel)
            HStack(alignment: .top, spacing: 8) {
                Circle()
                    .frame(width: 4, height: 4)
                    .foregroundStyle(Color(light: Color.Gray.gray800, dark: Color.Teal.teal500))
                    .padding(.top, 6)
                Text(state.safetyDescription)
                    .font(Font.AppFont.textCaption)
                    .foregroundStyle(Color(light: Color.Gray.gray800, dark: Color.Teal.teal500))
            }
        }
    }
}

#Preview {
    ProductSafetySection(state: ProductDetailsUIState.mock.safetyState)
        .padding()
}
