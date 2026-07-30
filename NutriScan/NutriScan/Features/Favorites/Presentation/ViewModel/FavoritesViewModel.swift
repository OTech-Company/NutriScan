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

    // MARK: - Add Meal State

    /// True while the add-meal network call is in-flight for a given card.
    var isAddingMeal: Bool = false
    /// Non-nil when an add-meal call succeeds, holding the scanId that was just added.
    var lastAddedMealScanId: String? = nil
    /// Non-nil when an add-meal call fails.
    var addMealError: String? = nil
    
    private var currentPage: Int = 0
    private var hasMorePages: Bool = true
    private let pageSize: Int = 20
    
    let favoritesUseCase: FavoritesUseCaseProtocol
    private let notifier: FavoritesNotifier
    private let addMealUseCase: AddMealUseCaseProtocol

    init(
        favoritesUseCase: FavoritesUseCaseProtocol,
        notifier: FavoritesNotifier = .shared,
        addMealUseCase: AddMealUseCaseProtocol = AddMealUseCase()
    ) {
        self.favoritesUseCase = favoritesUseCase
        self.notifier = notifier
        self.addMealUseCase = addMealUseCase
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
    
    // MARK: - Remove Favorite

    func removeFavorite(scanId: String) {
        guard let index = favorites.firstIndex(where: { $0.id == scanId }) else { return }
        let removed = favorites.remove(at: index)

        Task {
            do {
                try await favoritesUseCase.removeFavorite(scanId: scanId)
                notifier.setNeedsRefresh()
            } catch {
                await MainActor.run {
                    self.favorites.insert(removed, at: min(index, self.favorites.count))
                }
                print("Error removing favorite: \(error)")
            }
        }
    }

    // MARK: - Add to Daily Meals

    /// Calls POST to add the product, or PUT to increment if it already exists.
    /// Observable state: `isAddingMeal`, `lastAddedMealScanId`, `addMealError`.
    func addMealToDaily(scanId: String, completion: @escaping (Bool) -> Void) {
        guard !isAddingMeal else { return }
        isAddingMeal = true
        addMealError = nil
        lastAddedMealScanId = nil

        Task {
            do {
                try await addMealUseCase.execute(scanId: scanId)
                await MainActor.run {
                    self.lastAddedMealScanId = scanId
                    self.isAddingMeal = false
                    completion(true)
                }
            } catch {
                await MainActor.run {
                    self.addMealError = error.localizedDescription
                    self.isAddingMeal = false
                    completion(false)
                }
                print("Error adding meal to daily tracking: \(error)")
            }
        }
    }
}
