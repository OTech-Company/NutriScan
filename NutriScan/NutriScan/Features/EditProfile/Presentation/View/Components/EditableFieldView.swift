//
//  EditableFieldView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI

struct EditableFieldView: View {
    let placeholder: String
    @Binding var text: String
    var trailingIcon: String = "pencil"
    var isEditing: Bool = false

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .font(Font.AppFont.textPrimary)
                .foregroundColor(Color.EditProfileSemantics.textSecondary)
                .disabled(!isEditing)

            Image(systemName: trailingIcon)
                .foregroundColor(Color.EditProfileSemantics.textSecondary)
        }
        .padding(.horizontal, 16)
        .frame(height: EditProfileSemantics.Sizes.fieldHeight)
        .background(isEditing ? Color.EditProfileSemantics.editableSurface : Color.EditProfileSemantics.surfacePrimary)
        .overlay(
            RoundedRectangle(cornerRadius: EditProfileSemantics.Radius.field)
                .stroke(Color.EditProfileSemantics.borderPrimary, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: EditProfileSemantics.Radius.field))
    }
}
