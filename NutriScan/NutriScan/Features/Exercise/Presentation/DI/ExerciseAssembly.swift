//
//  ExerciseAssembly.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 27/07/2026.
//

import Foundation

struct ExerciseAssembly: Assembly {
    func assemble(container: DIContainer) {
        let repository = ExerciseRepositoryImpl()
        container.register(type: ExerciseRepositoryProtocol.self, component: repository)
        
        container.register(
            type: FetchExerciseCategoriesUseCaseProtocol.self,
            component: FetchExerciseCategoriesUseCase(repository: repository)
        )
        container.register(
            type: FetchExercisesUseCaseProtocol.self,
            component: FetchExercisesUseCase(repository: repository)
        )
    }
}
