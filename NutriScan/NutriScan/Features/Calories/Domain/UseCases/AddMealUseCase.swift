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

    func execute(date: String, scanId: String, mealCnt: Int) async throws -> Meal {
        try await repository.addMeal(date: date, scanId: scanId, mealCnt: mealCnt)
    }
}
