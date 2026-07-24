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
            emptyStateView
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

    private var emptyStateView: some View {
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
        .padding(.top, 60)
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
                paginationFooterView
            }
        }
    }

    private var paginationFooterView: some View {
        ProgressView()
            .tint(Color.Teal.teal1000)
            .padding(.vertical, 16)
    }
}

// MARK: - Preview

#Preview {
    ExerciseListView(viewModel: ExerciseListViewModel())
}
