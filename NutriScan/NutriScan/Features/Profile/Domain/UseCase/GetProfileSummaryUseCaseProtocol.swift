//
//  GetProfileSummaryUseCaseProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

protocol GetProfileSummaryUseCaseProtocol {
    func execute() async throws -> ProfileSummary
}
