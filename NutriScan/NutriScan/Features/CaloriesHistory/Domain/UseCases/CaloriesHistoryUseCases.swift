//
//  CaloriesHistoryUseCases.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import Foundation

protocol GetCaloriesHistoryPageUseCaseProtocol {
    func execute(page: Int, size: Int) async throws -> CaloriesHistoryPage
}

protocol GetCaloriesHistoryByDateUseCaseProtocol {
    func execute(date: Date) async throws -> CaloriesHistoryDay
}

struct GetCaloriesHistoryPageUseCase: GetCaloriesHistoryPageUseCaseProtocol {
    private let repository: CaloriesHistoryRepositoryProtocol

    init(repository: CaloriesHistoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int, size: Int) async throws -> CaloriesHistoryPage {
        try await repository.fetchHistory(page: page, size: size)
    }
}

struct GetCaloriesHistoryByDateUseCase: GetCaloriesHistoryByDateUseCaseProtocol {
    private let repository: CaloriesHistoryRepositoryProtocol

    init(repository: CaloriesHistoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute(date: Date) async throws -> CaloriesHistoryDay {
        try await repository.fetchHistory(for: date)
    }
}
