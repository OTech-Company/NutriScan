//
//  ProductDetailsService.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation

protocol ProductDetailsService {
    func fetchScanDetails(scanId: String) async throws -> ProductDetailsScanDTO
}

class ProductDetailsServiceImpl : ProductDetailsService {
    func fetchScanDetails(scanId: String) async throws -> ProductDetailsScanDTO {
        let response : ProductDetailsResponse
        
        response = try await NetworkService.shared.request(ProductDetailsEndPoint.getProductDetails(scanId: scanId))
        return response.product
    }
}
