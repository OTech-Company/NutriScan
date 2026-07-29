//
//  FavoritesUseCase.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import Foundation

protocol FavoritesUseCaseProtocol {
    func getFavorites(page: Int, size: Int) async throws -> (favorites: [FavoritesScanEntity], totalPages: Int)
    func removeFavorite(scanId: String) async throws
}

class FavoritesUseCase: FavoritesUseCaseProtocol {
    
    let favoritesRepository: FavoritesRepositoryProtocol
    
    init(favoritesRepository: FavoritesRepositoryProtocol) {
        self.favoritesRepository = favoritesRepository
    }
    
    func getFavorites(page: Int, size: Int) async throws -> (favorites: [FavoritesScanEntity], totalPages: Int) {
        return try await favoritesRepository.getFavorites(page: page, size: size)
    }
    
    func removeFavorite(scanId: String) async throws {
        try await favoritesRepository.removeFavorite(scanId: scanId)
    }
    
}
