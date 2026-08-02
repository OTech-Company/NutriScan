//
//  TermsViewModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class TermsViewModel {
    var termsItems: [TermsItem] = []
    var isLoading: Bool = false
    
    private let getTermsUseCase: GetTermsUseCaseProtocol
    
    init(
        getTermsUseCase: GetTermsUseCaseProtocol
    ) {
        self.getTermsUseCase = getTermsUseCase
    }
    
    func loadTerms() async {
        isLoading = true
        do {
            self.termsItems = try await getTermsUseCase.execute()
        } catch {
            print("Failed to load Terms: \(error)")
        }
        isLoading = false
    }
}
