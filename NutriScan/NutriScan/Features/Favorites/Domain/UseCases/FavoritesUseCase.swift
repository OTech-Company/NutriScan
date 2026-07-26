//
//  FavoritesUseCase.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import Foundation

protocol FavoritesUseCaseProtocol {
    func getFavorites(page: Int, size: Int) async throws -> (favorites: [FavoritesScanEntity], totalPages: Int)
}

class FavoritesUseCase: FavoritesUseCaseProtocol {
    
    let favoritesRepository: FavoritesRepositoryProtocol
    
    init(favoritesRepository: FavoritesRepositoryProtocol) {
        self.favoritesRepository = favoritesRepository
    }
    
    func getFavorites(page: Int, size: Int) async throws -> (favorites: [FavoritesScanEntity], totalPages: Int) {
        try await favoritesRepository.getFavorites(page: page, size: size)
    }
    
}
