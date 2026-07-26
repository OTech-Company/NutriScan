//
//  SafetyLevelText.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import SwiftUI

struct SafetyLevelText: View {
    let safetyLevel: SafetyLevel
    var body: some View {
        HStack(spacing:8) {
            Text(safetyLevel.rawValue)
                .font(Font.AppFont.subtitle2)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(safetyLevel.color)
                }
            Text("For you")
                .font(Font.AppFont.subtitle2)
                .foregroundStyle(Color(light: Color.Teal.teal1000, dark: Color.Teal.teal500))
            Spacer()
        }
    }
}

#Preview {
    SafetyLevelText(safetyLevel: SafetyLevel.caution)
}
