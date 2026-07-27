//
//  ProductDetailsService.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation

protocol ProductDetailsService {
    func fetchScanDetails(scanId: String) async throws -> ProductDetailsScanDTO
    func updateFavorite(scanId: String, isFavorite: Bool) async throws
}

class ProductDetailsServiceImpl : ProductDetailsService {
    func fetchScanDetails(scanId: String) async throws -> ProductDetailsScanDTO {
        let response : ProductDetailsResponse
        
        response = try await NetworkService.shared.request(ProductDetailsEndPoint.getProductDetails(scanId: scanId))
        return response.product
    }
    
    func updateFavorite(scanId: String, isFavorite: Bool) async throws {
        // We do not need the response payload but NetworkService requires a Decodable.
        // It returns the scan DTO directly based on swagger docs.
        let _ : ProductDetailsScanDTO = try await NetworkService.shared.request(ProductDetailsEndPoint.updateFavorite(scanId: scanId, isFavorite: isFavorite))
    }
}
