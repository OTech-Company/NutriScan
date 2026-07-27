//
//  FetchExercisesUseCase.swift
//  NutriScan
//

import Foundation

protocol FetchExercisesUseCaseProtocol {
    func execute(request: FetchExercisesRequest) async throws -> PaginatedExercisesResult
}

struct FetchExercisesUseCase: FetchExercisesUseCaseProtocol {
    private let repository: ExerciseRepositoryProtocol

    init(repository: ExerciseRepositoryProtocol = ExerciseRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: FetchExercisesRequest = FetchExercisesRequest()) async throws -> PaginatedExercisesResult {
        try await repository.fetchExercises(request: request)
    }
}
