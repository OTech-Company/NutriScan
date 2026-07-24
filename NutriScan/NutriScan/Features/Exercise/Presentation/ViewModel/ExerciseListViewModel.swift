//
//  ExerciseListViewModel.swift
//  NutriScan
//

import Foundation
import Observation

@Observable
final class ExerciseListViewModel {

    // MARK: - State
    var searchQuery: String = "" {
        didSet {
            onSearchQueryChanged()
        }
    }

    var selectedCategory: ExerciseCategory = .all {
        didSet {
            if oldValue != selectedCategory {
                onCategorySelected()
            }
        }
    }

    var selectedExercise: Exercise? = nil  // drives bottom sheet
    var isLoadingCategories: Bool = false
    var categoryError: String? = nil

    // MARK: - Exercises Pagination State
    var exercises: [Exercise] = []
    var isLoadingExercises: Bool = false
    var isLoadingMore: Bool = false
    var hasNextPage: Bool = true
    var currentPage: Int = 1
    var exercisesError: String? = nil

    // MARK: - Data
    var categories: [ExerciseCategory] = [.all]

    private let fetchCategoriesUseCase: FetchExerciseCategoriesUseCase
    private let fetchExercisesUseCase: FetchExercisesUseCase
    private var searchTask: Task<Void, Never>? = nil

    init(
        fetchCategoriesUseCase: FetchExerciseCategoriesUseCase = FetchExerciseCategoriesUseCase(),
        fetchExercisesUseCase: FetchExercisesUseCase = FetchExercisesUseCase()
    ) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
        self.fetchExercisesUseCase = fetchExercisesUseCase
    }

    // MARK: - Categories Networking

    func loadCategories() async {
        isLoadingCategories = true
        categoryError = nil
        defer { isLoadingCategories = false }
        do {
            self.categories = try await fetchCategoriesUseCase.execute()
        } catch {
            self.categoryError = error.localizedDescription
        }
    }

    // MARK: - Exercises Networking & Pagination

    func loadInitialExercises() async {
        currentPage = 1
        hasNextPage = true
        isLoadingExercises = true
        exercisesError = nil

        defer { isLoadingExercises = false }

        do {
            let bodyPartFilter = (selectedCategory == .all) ? nil : selectedCategory.id
            let queryFilter = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)

            let request = FetchExercisesRequest(
                page: 1,
                limit: 20,
                bodyPart: bodyPartFilter,
                searchQuery: queryFilter.isEmpty ? nil : queryFilter
            )

            let result = try await fetchExercisesUseCase.execute(request: request)

            self.exercises = result.exercises
            self.hasNextPage = result.hasNext
            self.currentPage = result.currentPage
        } catch {
            self.exercisesError = error.localizedDescription
        }
    }

    func loadNextPage() async {
        guard !isLoadingMore, !isLoadingExercises, hasNextPage else { return }

        isLoadingMore = true
        defer { isLoadingMore = false }

        let nextPage = currentPage + 1
        let bodyPartFilter = (selectedCategory == .all) ? nil : selectedCategory.id
        let queryFilter = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            let request = FetchExercisesRequest(
                page: nextPage,
                limit: 20,
                bodyPart: bodyPartFilter,
                searchQuery: queryFilter.isEmpty ? nil : queryFilter
            )

            let result = try await fetchExercisesUseCase.execute(request: request)

            self.exercises.append(contentsOf: result.exercises)
            self.hasNextPage = result.hasNext
            self.currentPage = result.currentPage
        } catch {
            // Silently handle page load errors or keep state
        }
    }

    private func onCategorySelected() {
        Task { @MainActor in
            await loadInitialExercises()
        }
    }

    private func onSearchQueryChanged() {
        searchTask?.cancel()
        searchTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 400_000_000) // 400ms debounce
            guard !Task.isCancelled else { return }
            await loadInitialExercises()
        }
    }
}
