//
//  ExerciseListView.swift
//  NutriScan
//

import SwiftUI

struct ExerciseListView: View {
    let exercises: [Exercise]
    let onSelect: (Exercise) -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                if exercises.isEmpty {
                    emptyState
                        .padding(.top, 60)
                } else {
                    ForEach(exercises) { exercise in
                        ExerciseRowCard(exercise: exercise) {
                            onSelect(exercise)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44, weight: .light))
                .foregroundColor(Color.Teal.teal400)

            Text("No exercises found")
                .font(Font.AppFont.subtitle2)
                .foregroundColor(Color.ExerciseSemantic.rowTitle)

            Text("Try a different search or category")
                .font(Font.AppFont.textSecondary)
                .foregroundColor(Color.ExerciseSemantic.rowSubtitle)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Preview

#Preview {
    ExerciseListView(
        exercises: [
            Exercise(
                id: "1",
                name: "Full Body Warm Up",
                equipment: "equipment",
                target: "target",
                category: "Warm Up",
                imageName: "figure.walk",
                instructions: "Sample instructions."
            )
        ],
        onSelect: { _ in }
    )
}
