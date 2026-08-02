//
//  TermsRepositoryImpl.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

final class TermsRepositoryImpl: TermsRepositoryProtocol {
    private let localDataSource: TermsLocalDataSourceProtocol
    
    init(localDataSource: TermsLocalDataSourceProtocol = DIContainer.shared.resolve(type: TermsLocalDataSourceProtocol.self)) {
        self.localDataSource = localDataSource
    }
    
    func getTerms() async throws -> [TermsItem] {
        return try await localDataSource.getTerms()
    }
}
