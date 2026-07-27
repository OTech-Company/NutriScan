//
//  GetProductDetailsUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation

final class GetProductDetailsUseCase {
    private let repository: ProductDetailsRepo

    init(repository: ProductDetailsRepo) {
        self.repository = repository
    }

    func execute(scanId: String) async throws -> ProductDetails {
        return try await repository.getProductDetails(scanId: scanId)
    }
}
