//
//  InputChip.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI

struct InputChip: View {
    @Binding var text: String
    let onSubmit: () -> Void
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 0) {
            TextField("Enter...", text: $text)
                .focused($isFocused)
                .font(Font.AppFont.textSecondary)
                .foregroundColor(Color.ChipSemantics.defaultText)
                .fixedSize(horizontal: true, vertical: false)
                .onSubmit {
                    onSubmit()
                }
                .onAppear {
                    isFocused = true
                }
        }
        .padding(.horizontal, SelectableChipConstants.horizontalPadding)
        .frame(minWidth: 80, minHeight: SelectableChipConstants.height)
        .background(Color.ChipSemantics.defaultBackground)
        .overlay(
            RoundedRectangle(cornerRadius: SelectableChipConstants.cornerRadius)
                .strokeBorder(Color.ChipSemantics.addBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: SelectableChipConstants.cornerRadius))
    }
}

