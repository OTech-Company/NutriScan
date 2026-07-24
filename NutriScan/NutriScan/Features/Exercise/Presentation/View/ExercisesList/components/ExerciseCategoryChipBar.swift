//
//  ExerciseCategoryChipBar.swift
//  NutriScan
//

import SwiftUI

// MARK: - Category Chip Bar

struct ExerciseCategoryChipBar: View {
    let categories: [String]
    @Binding var selectedCategory: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    ExerciseCategoryChip(
                        title: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.leading, 20)   // aligns with screen leading edge
            .padding(.trailing, 20)
        }
    }
}

// MARK: - Exercise Category Chip
// Custom chip — bg is always white; only text & border color change on selection.
// Unselected : text Gray/700  · border Gray/400
// Selected   : text Teal/1000 · border Teal/1000

private struct ExerciseCategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Font.AppFont.textSecondary)
                .foregroundColor(isSelected ? Color.ExerciseSemantic.categoryChipTextSelected : Color.ExerciseSemantic.categoryChipTextUnselected)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(height: 34)
                .background(Color.ExerciseSemantic.categoryChipBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .strokeBorder(
                            isSelected ? Color.ExerciseSemantic.categoryChipBorderSelected : Color.ExerciseSemantic.categoryChipBorderUnselected,
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
    VStack(spacing: 20) {
        ExerciseCategoryChipBar(
            categories: ["All", "Warm Up", "Strength", "Core"],
            selectedCategory: .constant("All")
        )
        ExerciseCategoryChipBar(
            categories: ["All", "Warm Up", "Strength", "Core"],
            selectedCategory: .constant("Warm Up")
        )
    }
    .padding()
}
