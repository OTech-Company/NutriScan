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
    private let notifier: FavoritesNotifier
    
    init(favoritesUseCase: FavoritesUseCaseProtocol, notifier: FavoritesNotifier = .shared) {
        self.favoritesUseCase = favoritesUseCase
        self.notifier = notifier
    }
    
    /// Called every time the screen appears. Only fetches if data is stale.
    func loadIfNeeded() async {
        guard notifier.needsRefresh else { return }
        await loadFavorites()
    }
    
    func loadFavorites(search: String? = nil) async {
        currentPage = 0
        hasMorePages = true
        favorites.removeAll()
        
        if let search = search, !search.isEmpty {
            await fetchAllAndFilter(search: search)
        } else {
            await fetchFavorites()
        }
        
        // Mark as refreshed only when not searching (search is a transient view)
        if search == nil || search!.isEmpty {
            notifier.didRefresh()
        }
    }
    
    
    func loadNextPageIfNeeded(currentItem: FavoritesScanEntity, search: String? = nil) {
        guard let lastItem = favorites.last, lastItem.id == currentItem.id else { return }
        guard !isLoadingFavorites && hasMorePages else { return }
        
        if search == nil || search!.isEmpty {
            Task {
                await fetchFavorites()
            }
        }
    }
    
    private func fetchAllAndFilter(search: String) async {
        isLoadingFavorites = true
        loadFavoritesError = nil
        
        var allFetched: [FavoritesScanEntity] = []
        var page = 0
        var morePages = true
        let fetchSize = 100
        
        do {
            while morePages {
                let result = try await favoritesUseCase.getFavorites(page: page, size: fetchSize)
                allFetched.append(contentsOf: result.favorites)
                page += 1
                morePages = page < result.totalPages
            }
            
            favorites = allFetched.filter { $0.productName.localizedCaseInsensitiveContains(search) }
            hasMorePages = false
        } catch {
            loadFavoritesError = error.localizedDescription
        }
        
        isLoadingFavorites = false
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
