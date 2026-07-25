//
//  ExerciseCategoryChipBar.swift
//  NutriScan
//

import SwiftUI
import Shimmer

struct ExerciseCategoryChipBar: View {
    let categories: [ExerciseCategory]
    @Binding var selectedCategory: ExerciseCategory
    var isLoading: Bool = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if isLoading {
                    ForEach(ExerciseCategory.dummyList) { dummy in
                        ExerciseCategoryChip(title: dummy.name, isSelected: false, action: {})
                            .redacted(reason: .placeholder)
                            .shimmering()
                    }
                } else {
                    ForEach(categories) { category in
                        ExerciseCategoryChip(
                            title: category.name,
                            isSelected: selectedCategory == category
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedCategory = category
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        ExerciseCategoryChipBar(
            categories: [.all, ExerciseCategory(id: "warm up", name: "Warm Up"), ExerciseCategory(id: "strength", name: "Strength")],
            selectedCategory: .constant(.all)
        )
        ExerciseCategoryChipBar(
            categories: [],
            selectedCategory: .constant(.all),
            isLoading: true
        )
    }
    .padding(.vertical)
}
