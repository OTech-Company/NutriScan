//
//  FavoritesUseCase.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import Foundation

protocol FavoritesUseCaseProtocol {
    func getFavorites() async throws -> [FavoritesScanEntity]
}

class FavoritesUseCase: FavoritesUseCaseProtocol {
    
    let favoritesRepository: FavoritesRepositoryProtocol
    
    init(favoritesRepository: FavoritesRepositoryProtocol) {
        self.favoritesRepository = favoritesRepository
    }
    
    func getFavorites() async throws -> [FavoritesScanEntity] {
        try await favoritesRepository.getAllFavorites()
    }
    
}
