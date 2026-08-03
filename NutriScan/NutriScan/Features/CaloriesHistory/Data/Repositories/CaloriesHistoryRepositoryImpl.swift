//
//  CaloriesHistoryRepositoryImpl.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import Foundation

final class CaloriesHistoryRepositoryImpl: CaloriesHistoryRepositoryProtocol {
    private let remoteDataSource: CaloriesHistoryRemoteDataSourceProtocol

    init(remoteDataSource: CaloriesHistoryRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchHistory(page: Int, size: Int) async throws -> CaloriesHistoryPage {
        CaloriesHistoryMapper.map(
            try await remoteDataSource.fetchHistory(page: page, size: size)
        )
    }

    func fetchHistory(for date: Date) async throws -> CaloriesHistoryDay {
        do {
            return try CaloriesHistoryMapper.map(
                try await remoteDataSource.fetchHistory(for: date)
            )
        } catch NetworkError.serverError(statusCode: 404) {
            throw CaloriesHistoryError.notFound
        } catch let NetworkError.apiError(response) where response.status == 404 {
            throw CaloriesHistoryError.notFound
        }
    }
}
