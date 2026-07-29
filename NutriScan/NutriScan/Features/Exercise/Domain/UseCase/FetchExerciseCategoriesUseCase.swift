//
//  FetchExerciseCategoriesUseCase.swift
//  NutriScan
//

import Foundation

protocol FetchExerciseCategoriesUseCaseProtocol {
    func execute() async throws -> [ExerciseCategory]
}

struct FetchExerciseCategoriesUseCase: FetchExerciseCategoriesUseCaseProtocol {
    private let repository: ExerciseRepositoryProtocol

    init(repository: ExerciseRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [ExerciseCategory] {
        try await repository.fetchCategories()
    }
}
