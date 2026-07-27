//
//  ExerciseCategoryChip.swift
//  NutriScan
//

import SwiftUI

struct ExerciseCategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Font.AppFont.textSecondary)
                .foregroundColor(
                    isSelected
                        ? Color.ExerciseSemantic.categoryChipTextSelected
                        : Color.ExerciseSemantic.categoryChipTextUnselected
                )
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(height: 34)
                .background(Color.ExerciseSemantic.categoryChipBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .strokeBorder(
                            isSelected
                                ? Color.ExerciseSemantic.categoryChipBorderSelected
                                : Color.ExerciseSemantic.categoryChipBorderUnselected,
                            lineWidth: 1
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 32))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 8) {
        ExerciseCategoryChip(title: "All", isSelected: true, action: {})
        ExerciseCategoryChip(title: "Cardio", isSelected: false, action: {})
    }
    .padding()
}
