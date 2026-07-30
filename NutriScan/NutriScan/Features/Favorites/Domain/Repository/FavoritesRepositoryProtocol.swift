//
//  FavoritesRepository.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import Foundation

protocol FavoritesRepositoryProtocol {
    func getFavorites(page: Int, size: Int) async throws -> (favorites: [FavoritesScanEntity], totalPages: Int)
    func removeFavorite(scanId: String) async throws
}
