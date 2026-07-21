//
//  MeasureFieldView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 21/07/2026.
//

import SwiftUI

struct MeasureFieldView: View {
    let label: String
    @Binding var value: String
    var unit: String = ""

    var body: some View {
        HStack(spacing: 6) {
            Text(label)
                .font(Font.AppFont.textPrimary)
                .foregroundColor(Color.EditProfileSemantics.textSecondary)

            Spacer()

            TextField("", text: $value)
                .font(Font.AppFont.textPrimary)
                .foregroundColor(Color.EditProfileSemantics.textSecondary)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .fixedSize()

            if !unit.isEmpty {
                Text(unit)
                    .font(Font.AppFont.textPrimary)
                    .foregroundColor(Color.EditProfileSemantics.textSecondary)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: EditProfileSemantics.Sizes.fieldHeight)
        .frame(maxWidth: .infinity)
        .background(Color.EditProfileSemantics.surfacePrimary)
        .overlay(
            RoundedRectangle(cornerRadius: EditProfileSemantics.Radius.field)
                .stroke(Color.EditProfileSemantics.borderPrimary, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: EditProfileSemantics.Radius.field))
    }
}

#Preview("Light") {
    HStack(spacing: 12) {
        MeasureFieldView(label: "Hight", value: .constant("180"), unit: "cm")
        MeasureFieldView(label: "Weight", value: .constant("80"), unit: "kg")
    }
    .padding()
    .background(Color.EditProfileSemantics.backgroundPrimary)
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    HStack(spacing: 12) {
        MeasureFieldView(label: "Hight", value: .constant("180"), unit: "cm")
        MeasureFieldView(label: "Weight", value: .constant("80"), unit: "kg")
    }
    .padding()
    .background(Color.EditProfileSemantics.backgroundPrimary)
    .preferredColorScheme(.dark)
}
