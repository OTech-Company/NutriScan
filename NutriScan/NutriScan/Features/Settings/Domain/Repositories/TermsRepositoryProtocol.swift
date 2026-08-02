//
//  TermsRepositoryProtocol.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

protocol TermsRepositoryProtocol {
    func getTerms() async throws -> [TermsItem]
}
