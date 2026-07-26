//
//  ProductDetailsViewModel.swift
//  NutriScan
//
//  Created by albaraa alsayed on 12/02/1448 AH.
//

import Foundation
import Observation

@Observable
@MainActor
final class ProductDetailsViewModel {
    var uiState: ProductDetailsUIState?
    var isLoading = false
    var failureMessage: String?
    
    private let useCase: GetProductDetailsUseCase
    private let scanId: String
    
    init(scanId: String, useCase: GetProductDetailsUseCase = DIContainer.shared.resolve(type: GetProductDetailsUseCase.self)) {
        self.scanId = scanId
        self.useCase = useCase
    }
    
    func loadProductDetails() async {
        isLoading = true
        failureMessage = nil
        defer { isLoading = false }
        
        do {
            let details = try await useCase.execute(scanId: scanId)
            self.uiState = ProductDetailsUIState(from: details)
        } catch let error as NetworkError {
            failureMessage = error.localizedDescription
        } catch {
            failureMessage = "An unexpected error occurred."
        }
    }
}
