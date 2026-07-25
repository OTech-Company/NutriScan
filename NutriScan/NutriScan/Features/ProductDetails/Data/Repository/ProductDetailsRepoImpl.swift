//
//  ProductDetailsRepoImpl.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation

class ProductDetailsRepoImpl: ProductDetailsRepo {
    let service : ProductDetailsService
    
    func getProductDetails(scanId: String) async throws -> ProductDetails {
        ProductDetails(from: try await service.fetchScanDetails(scanId: scanId))
    }
    
    init(service: ProductDetailsService) {
        self.service = service
    }
}
