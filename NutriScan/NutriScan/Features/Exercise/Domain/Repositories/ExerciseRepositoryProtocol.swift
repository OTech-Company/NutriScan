//
//  ExerciseRepositoryProtocol.swift
//  NutriScan
//

protocol ExerciseRepositoryProtocol {
    func fetchExercises() async throws -> [Exercise]
    func fetchCategories() async throws -> [ExerciseCategory]
}
