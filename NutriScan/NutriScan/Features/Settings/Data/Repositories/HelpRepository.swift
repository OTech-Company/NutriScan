//
//  HelpRepository.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//
import Foundation

final class HelpRepository: HelpRepositoryProtocol {
    private let localDataSource: HelpLocalDataSourceProtocol
    
    init(localDataSource: HelpLocalDataSourceProtocol) {
        self.localDataSource = localDataSource
    }
    
    func getFaqs() async throws -> [FaqItem] {
        return try await localDataSource.getFaqs()
    }
}
