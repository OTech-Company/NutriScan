//
//  AddMealUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

final class AddMealUseCase {
    private let repository: DailyTrackingRepo

    init(repository: DailyTrackingRepo) {
        self.repository = repository
    }

    func execute(date: String, meal: Meal) async throws -> Meal {
        try await repository.addMeal(date: date, meal: meal)
    }
}
