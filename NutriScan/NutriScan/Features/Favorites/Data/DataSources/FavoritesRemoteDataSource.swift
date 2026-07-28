//
//  FavoritesRemoteDataSource.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import Foundation

protocol FavoritesRemoteDataSourceProtocol {
    func getFavorites(page: Int, size: Int) async throws -> FavoritesPaginatedScanResponseDTO
    func removeFavorite(scanId: String) async throws
}

class FavoritesRemoteDataSource: FavoritesRemoteDataSourceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func getFavorites(page: Int, size: Int) async throws -> FavoritesPaginatedScanResponseDTO {
        let endpoint = FavoritesEndpoint.getFavorites(page: page, size: size)
        return try await networkService.request(endpoint)
    }
    
    func removeFavorite(scanId: String) async throws {
        let endpoint = FavoritesEndpoint.removeFavorite(scanId: scanId)
        let _: FavoritesScanItemDTO = try await networkService.request(endpoint)
    }
}
