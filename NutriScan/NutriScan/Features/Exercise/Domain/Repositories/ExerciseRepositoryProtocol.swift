//
//  ExerciseRepositoryProtocol.swift
//  NutriScan
//

protocol ExerciseRepositoryProtocol {
    func fetchExercises() async throws -> [Exercise]
}
