//
//  FavoritesViewModel.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import Foundation

@Observable
class FavoritesViewModel {
    var favorites: [FavoritesScanEntity] = []
    var isLoadingFavorites: Bool = false
    var loadFavoritesError: String? = nil
    
    let favoritesUseCase: FavoritesUseCaseProtocol
    
    init(favoritesUseCase: FavoritesUseCaseProtocol) {
        self.favoritesUseCase = favoritesUseCase
    }
    
    func loadFavorites() async {
        guard favorites.isEmpty else { return }
        
        isLoadingFavorites = true
        loadFavoritesError = nil
        
        do {
            let favs = try await favoritesUseCase.getFavorites()
            print(favs.count)
            favorites = favs
        } catch {
            print(error.localizedDescription)
            loadFavoritesError = error.localizedDescription
        }
        isLoadingFavorites = false
        
    }
}
