//
//  UpdateMealUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

final class UpdateMealUseCase {
    private let repository: DailyTrackingRepo

    init(repository: DailyTrackingRepo) {
        self.repository = repository
    }

    func execute(date: String, scanId: String, meal: Meal) async throws -> Meal {
        try await repository.updateMeal(date: date, scanId: scanId, meal: meal)
    }
}
