//
//  ExerciseRepositoryProtocol.swift
//  NutriScan
//

import Foundation

protocol ExerciseRepositoryProtocol {
    func fetchExercises(request: FetchExercisesRequest) async throws -> PaginatedExercisesResult
    func fetchCategories() async throws -> [ExerciseCategory]
}
