//
//  ExercisesView.swift
//  NutriScan
//

import SwiftUI

struct ExercisesView: View {
    @EnvironmentObject private var router: AppRouter

    @State private var viewModel = ExerciseListViewModel()

    var body: some View {
        VStack(spacing: 0) {

            // MARK: Navigation Bar
            navigationBar
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 16)

            // MARK: Search Bar
            ExerciseSearchBar(text: $viewModel.searchQuery)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)

            // MARK: Category Chips
            ExerciseCategoryChipBar(
                categories: viewModel.categories,
                selectedCategory: $viewModel.selectedCategory
            )
            .padding(.bottom, 16)

            // MARK: Exercise List
            ExerciseListView(
                exercises: viewModel.filteredExercises,
                onSelect: { exercise in
                    viewModel.selectedExercise = exercise
                }
            )
        }
        .background(Color.ExerciseSemantic.screenBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        // MARK: Bottom Sheet
        .sheet(item: $viewModel.selectedExercise) { exercise in
            ExerciseDetailSheet(exercise: exercise) {
                let activeExercise = exercise
                viewModel.selectedExercise = nil
                router.push(ExerciseRoute.workoutPlayer(exercise: activeExercise))
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(24)
            .presentationBackground(Color.ExerciseSemantic.sheetBackground)
        }
    }

    // MARK: - Navigation Bar

    private var navigationBar: some View {
        HStack(spacing: 16) {
            BackButton {
                router.pop()
            }

            Text("Exercises")
                .font(Font.AppFont.subtitle1)
                .foregroundColor(Color.ExerciseSemantic.rowTitle)

            Spacer()
        }
    }
}

// MARK: - Previews

#Preview("Light") {
    ExercisesView()
        .environmentObject(AppRouter())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ExercisesView()
        .environmentObject(AppRouter())
        .preferredColorScheme(.dark)
}
