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
    var isLoadingInitial: Bool = false
    var isLoadingNextPage: Bool = false
    var isRefreshing: Bool = false
    
    /// Non-nil only when the very first fetch (page 0) fails and the list is empty.
    var initialLoadError: String? = nil
    /// Non-nil when a subsequent page fetch fails — shown as an inline footer.
    var paginationError: String? = nil
    
    private var currentPage: Int = 0
    private var hasMorePages: Bool = true
    private let pageSize: Int = 20
    
    let favoritesUseCase: FavoritesUseCaseProtocol
    private let notifier: FavoritesNotifier
    
    init(favoritesUseCase: FavoritesUseCaseProtocol, notifier: FavoritesNotifier = .shared) {
        self.favoritesUseCase = favoritesUseCase
        self.notifier = notifier
    }
    
    // MARK: - Public API
    
    /// Called every time the screen appears. Only fetches if data is stale.
    func loadIfNeeded() async {
        guard notifier.needsRefresh else { return }
        await loadFavorites()
    }
    
    /// Initial load or search — resets pagination and fetches page 0.
    func loadFavorites(search: String? = nil) async {
        currentPage = 0
        hasMorePages = true
        initialLoadError = nil
        paginationError = nil
        
        if let search = search, !search.isEmpty {
            favorites.removeAll()
            await fetchAllAndFilter(search: search)
        } else {
            isLoadingInitial = true
            favorites.removeAll()
            await fetchPage()
        }
        
        // Mark as refreshed only when not searching
        if search == nil || search!.isEmpty {
            notifier.didRefresh()
        }
    }
    
    /// Pull-to-refresh — keeps existing data if the refresh fails.
    func refreshFavorites() async {
        isRefreshing = true
        paginationError = nil
        
        let previousFavorites = favorites
        let previousPage = currentPage
        let previousHasMore = hasMorePages
        
        currentPage = 0
        hasMorePages = true
        
        do {
            let result = try await favoritesUseCase.getFavorites(page: 0, size: pageSize)
            favorites = result.favorites
            currentPage = 1
            hasMorePages = currentPage < result.totalPages
            initialLoadError = nil
            notifier.didRefresh()
        } catch {
            favorites = previousFavorites
            currentPage = previousPage
            hasMorePages = previousHasMore
        }
        
        isRefreshing = false
    }
    
    /// Triggered by onAppear of the last item in the grid.
    func loadNextPageIfNeeded(currentItem: FavoritesScanEntity, search: String? = nil) {
        guard let lastItem = favorites.last, lastItem.id == currentItem.id else { return }
        guard !isLoadingNextPage && !isLoadingInitial && hasMorePages else { return }
        guard paginationError == nil else { return }
        
        if search == nil || search!.isEmpty {
            Task {
                await fetchNextPage()
            }
        }
    }
    
    /// Retry loading the next page after a pagination error.
    func retryPagination() {
        paginationError = nil
        Task {
            await fetchNextPage()
        }
    }
    
    // MARK: - Private Fetch Methods
    
    private func fetchPage() async {
        do {
            let result = try await favoritesUseCase.getFavorites(page: 0, size: pageSize)
            favorites = result.favorites
            currentPage = 1
            hasMorePages = currentPage < result.totalPages
            initialLoadError = nil
        } catch {
            if favorites.isEmpty {
                initialLoadError = error.localizedDescription
            }
        }
        
        isLoadingInitial = false
    }
    
    private func fetchNextPage() async {
        guard !isLoadingNextPage && hasMorePages else { return }
        isLoadingNextPage = true
        paginationError = nil
        
        do {
            let result = try await favoritesUseCase.getFavorites(page: currentPage, size: pageSize)
            favorites.append(contentsOf: result.favorites)
            currentPage += 1
            hasMorePages = currentPage < result.totalPages
        } catch {
            paginationError = error.localizedDescription
        }
        
        isLoadingNextPage = false
    }
    
    private func fetchAllAndFilter(search: String) async {
        isLoadingInitial = true
        
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
            if favorites.isEmpty {
                initialLoadError = error.localizedDescription
            }
        }
        
        isLoadingInitial = false
    }
}
