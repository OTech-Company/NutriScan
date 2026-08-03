//
//  CaloriesHistoryRepositoryProtocol.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import Foundation

protocol CaloriesHistoryRepositoryProtocol {
    func fetchHistory(page: Int, size: Int) async throws -> CaloriesHistoryPage
    func fetchHistory(for date: Date) async throws -> CaloriesHistoryDay
}
