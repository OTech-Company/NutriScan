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
    
    private var currentPage: Int = 0
    private var hasMorePages: Bool = true
    private let pageSize: Int = 20
    
    let favoritesUseCase: FavoritesUseCaseProtocol
    
    init(favoritesUseCase: FavoritesUseCaseProtocol) {
        self.favoritesUseCase = favoritesUseCase
    }
    
    func loadFavorites() async {
        guard favorites.isEmpty else { return }
        
        currentPage = 0
        hasMorePages = true
        favorites.removeAll()
        
        await fetchFavorites()
    }
    
    
    func loadNextPageIfNeeded(currentItem: FavoritesScanEntity) {
        guard let lastItem = favorites.last, lastItem.id == currentItem.id else { return }
        guard !isLoadingFavorites && hasMorePages else { return }
        
        Task {
            await fetchFavorites()
        }
    }
    
    func fetchFavorites() async {
        guard !isLoadingFavorites && hasMorePages else { return }
        isLoadingFavorites = true
        loadFavoritesError = nil
        
        do {
            let result = try await favoritesUseCase.getFavorites(page: currentPage, size: pageSize)
            
            favorites.append(contentsOf: result.favorites)
            
            currentPage += 1
            hasMorePages = currentPage < result.totalPages
        } catch {
            loadFavoritesError = error.localizedDescription
        }
        
        isLoadingFavorites = false
    }
}
