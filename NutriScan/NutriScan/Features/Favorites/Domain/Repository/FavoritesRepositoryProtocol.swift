//
//  FavoritesRepository.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import Foundation

protocol FavoritesRepositoryProtocol {
    
    func getAllFavorites() async throws -> [FavoritesScanEntity]
}
