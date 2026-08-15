//
//  CaloriesHistoryRemoteDataSource.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import Foundation

protocol CaloriesHistoryRemoteDataSourceProtocol {
    func fetchHistory(page: Int, size: Int) async throws -> CaloriesHistoryPageDTO
    func fetchHistory(for date: Date) async throws -> CaloriesHistoryDetailDTO
}

final class CaloriesHistoryRemoteDataSource: CaloriesHistoryRemoteDataSourceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchHistory(page: Int, size: Int) async throws -> CaloriesHistoryPageDTO {
        try await networkService.request(
            CaloriesHistoryEndpoint.history(page: page, size: size)
        )
    }

    func fetchHistory(for date: Date) async throws -> CaloriesHistoryDetailDTO {
        try await networkService.request(
            CaloriesHistoryEndpoint.historyByDate(CaloriesHistoryDateCodec.string(from: date))
        )
    }
}

enum CaloriesHistoryDateCodec {
    static func string(from date: Date, calendar sourceCalendar: Calendar = .current) -> String {
        var calendar = sourceCalendar
        calendar.locale = Locale(identifier: "en_US_POSIX")
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return String(
            format: "%04d-%02d-%02d",
            components.year ?? 0,
            components.month ?? 0,
            components.day ?? 0
        )
    }

    static func date(from value: String, calendar sourceCalendar: Calendar = .current) -> Date? {
        let parts = value.split(separator: "-", omittingEmptySubsequences: false)
        guard parts.count == 3,
              parts[0].count == 4,
              parts[1].count == 2,
              parts[2].count == 2,
              let year = Int(parts[0]),
              let month = Int(parts[1]),
              let day = Int(parts[2]) else {
            return nil
        }

        var calendar = sourceCalendar
        calendar.locale = Locale(identifier: "en_US_POSIX")
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = calendar.timeZone
        components.year = year
        components.month = month
        components.day = day

        guard let date = calendar.date(from: components) else { return nil }
        let verified = calendar.dateComponents([.year, .month, .day], from: date)
        guard verified.year == year, verified.month == month, verified.day == day else {
            return nil
        }
        return date
    }
}
