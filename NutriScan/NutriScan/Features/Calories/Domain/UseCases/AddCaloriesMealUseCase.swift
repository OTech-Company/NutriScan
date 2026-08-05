//
//  AddMealUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

protocol AddCaloriesMealUseCaseProtocol {
    func execute(date: String, scanId: String, mealCnt: Int) async throws -> CalorieMeal
}

final class AddCaloriesMealUseCase: AddCaloriesMealUseCaseProtocol {
    private let repository: CaloriesTrackingRepo

    init(repository: CaloriesTrackingRepo) {
        self.repository = repository
    }

    func execute(date: String, scanId: String, mealCnt: Int) async throws -> CalorieMeal {
        try await repository.addMeal(date: date, scanId: scanId, mealCnt: mealCnt)
    }
}
