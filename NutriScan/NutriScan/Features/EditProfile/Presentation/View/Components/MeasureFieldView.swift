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
    
    // Configurable limit
    var maxLength: Int = 3
    var isEditing: Bool = false

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
                .disabled(!isEditing)
                .onChange(of: value) { oldValue, newValue in
                    sanitizeInput(newValue: newValue)
                }

            if !unit.isEmpty {
                Text(unit)
                    .font(Font.AppFont.textPrimary)
                    .foregroundColor(Color.EditProfileSemantics.textSecondary)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: EditProfileSemantics.Sizes.fieldHeight)
        .frame(maxWidth: .infinity)
        .background(isEditing ? Color.EditProfileSemantics.editableSurface : Color.EditProfileSemantics.surfacePrimary)
        .overlay(
            RoundedRectangle(cornerRadius: EditProfileSemantics.Radius.field)
                .stroke(Color.EditProfileSemantics.borderPrimary, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: EditProfileSemantics.Radius.field))
    }
    
    // text formatting and length capping
    private func sanitizeInput(newValue: String) {
        // Strip out any non-numeric characters (e.g., if pasted)
        let numericString = newValue.filter { $0.isNumber }
        
        // Cap the length to maxLength
        if numericString.count > maxLength {
            value = String(numericString.prefix(maxLength))
        } else if newValue != numericString {
            // Update the value if invalid characters were removed
            value = numericString
        }
    }
}

#Preview("Light") {
    HStack(spacing: 12) {
        MeasureFieldView(label: "Height", value: .constant("180"), unit: "cm", isEditing: true)
        MeasureFieldView(label: "Weight", value: .constant("80"), unit: "kg", isEditing: true)
    }
    .padding()
    .background(Color.EditProfileSemantics.backgroundPrimary)
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    HStack(spacing: 12) {
        MeasureFieldView(label: "Height", value: .constant("180"), unit: "cm", isEditing: true)
        MeasureFieldView(label: "Weight", value: .constant("80"), unit: "kg", isEditing: true)
    }
    .padding()
    .background(Color.EditProfileSemantics.backgroundPrimary)
    .preferredColorScheme(.dark)
}
