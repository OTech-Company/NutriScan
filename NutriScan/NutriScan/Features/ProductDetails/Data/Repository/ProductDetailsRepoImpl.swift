//
//  ProductDetailsRepoImpl.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation

class ProductDetailsRepoImpl: ProductDetailsRepo {
    private let service: ProductDetailsService
    
    init(service: ProductDetailsService) {
        self.service = service
    }
    
    func getProductDetails(scanId: String) async throws -> ProductDetails {
        let response = try await service.fetchScanDetails(scanId: scanId)
        return ProductDetails(from: response)
    }
    
    func updateFavorite(scanId: String, isFavorite: Bool) async throws {
        try await service.updateFavorite(scanId: scanId, isFavorite: isFavorite)
    }
}
