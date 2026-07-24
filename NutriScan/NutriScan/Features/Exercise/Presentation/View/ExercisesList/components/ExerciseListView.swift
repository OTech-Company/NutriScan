//
//  ExerciseListView.swift
//  NutriScan
//

import SwiftUI
import Shimmer

struct ExerciseListView: View {
    var viewModel: ExerciseListViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                listContent
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
    }

    // MARK: - State Router

    @ViewBuilder
    private var listContent: some View {
        if viewModel.isLoadingExercises && viewModel.exercises.isEmpty {
            loadingStateView
        } else if viewModel.exercises.isEmpty {
            EmptyExerciseStateView()
        } else {
            contentListView
        }
    }

    // MARK: - Subviews

    private var loadingStateView: some View {
        VStack(spacing: 12) {
            ForEach(Exercise.dummyList) { dummyExercise in
                ExerciseRowCard(exercise: dummyExercise, onTap: {})
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
        }
    }

    private var contentListView: some View {
        Group {
            ForEach(viewModel.exercises) { exercise in
                ExerciseRowCard(exercise: exercise) {
                    viewModel.selectedExercise = exercise
                }
                .onAppear {
                    if exercise == viewModel.exercises.last {
                        Task {
                            await viewModel.loadNextPage()
                        }
                    }
                }
            }

            if viewModel.isLoadingMore {
                ProgressView()
                    .tint(Color.Teal.teal1000)
                    .padding(.vertical, 16)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ExerciseListView(viewModel: ExerciseListViewModel())
}
