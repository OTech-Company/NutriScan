//
//  FetchExercisesUseCase.swift
//  NutriScan
//

struct FetchExercisesUseCase {
    private let repository: ExerciseRepositoryProtocol

    init(repository: ExerciseRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Exercise] {
        try await repository.fetchExercises()
    }
}
