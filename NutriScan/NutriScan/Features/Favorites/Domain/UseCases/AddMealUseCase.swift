//
//  AddMealUseCase.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 30/07/2026.
//

import Foundation

protocol AddMealUseCaseProtocol {
    func execute(scanId: String) async throws
}

final class AddMealUseCase: AddMealUseCaseProtocol {

    private let repository: DailyTrackingRepositoryProtocol

    init(repository: DailyTrackingRepositoryProtocol = DailyTrackingRepository()) {
        self.repository = repository
    }

    func execute(scanId: String) async throws {
        try await repository.addOrIncrementMeal(scanId: scanId)
    }
}
