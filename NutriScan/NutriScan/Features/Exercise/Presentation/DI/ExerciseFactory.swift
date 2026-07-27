//
//  ExerciseFactory.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 27/07/2026.
//

import Foundation
import SwiftUI

enum ExerciseFactory {

    static func makeExerciseListViewModel() -> ExerciseListViewModel {
        let fetchCategoriesUseCase = DIContainer.shared.resolve(type: FetchExerciseCategoriesUseCaseProtocol.self)
        let fetchExercisesUseCase = DIContainer.shared.resolve(type: FetchExercisesUseCaseProtocol.self)
        return ExerciseListViewModel(
            fetchCategoriesUseCase: fetchCategoriesUseCase,
            fetchExercisesUseCase: fetchExercisesUseCase
        )
    }

    static func makeExercisesView() -> ExercisesView {
        let viewModel = makeExerciseListViewModel()
        return ExercisesView(viewModel: viewModel)
    }
}
