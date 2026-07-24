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
            HStack(spacing: 16) {
                BackButton {
                    router.pop()
                }
                Text("Exercises")
                    .font(Font.AppFont.subtitle1)
                    .foregroundColor(Color.ExerciseSemantic.rowTitle)
                Spacer()
            }
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
            ExerciseListView(viewModel: viewModel)
        }
        .background(Color.ExerciseSemantic.screenBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        .task {
            await viewModel.loadCategories()
            await viewModel.loadInitialExercises()
        }
        // MARK: Bottom Sheet
        .sheet(item: $viewModel.selectedExercise) { exercise in
            ExerciseDetailSheet(exercise: exercise) {
                let activeExercise = exercise
                viewModel.selectedExercise = nil
                router.push(ExerciseRoute.workoutPlayer(exercise: activeExercise))
            }
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
