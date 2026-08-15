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
    private(set) var hasCompletedInitialLoad: Bool = false

    /// Non-nil only when the very first fetch (page 0) fails or returns empty.
    var initialEmptyState: EmptyState? = nil
    /// Non-nil when a subsequent page fetch fails — shown as an inline footer.
    var paginationError: String? = nil

    // MARK: - Add Meal State

    /// Set of scanIds currently being added to daily meals.
    var addingMealIds: Set<String> = []
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
        guard !hasCompletedInitialLoad || notifier.needsRefresh else { return }
        await loadFavorites()
    }
    
    /// Initial load or search — resets pagination and fetches page 0.
    func loadFavorites(search: String? = nil) async {
        currentPage = 0
        hasMorePages = true
        initialEmptyState = nil
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

        hasCompletedInitialLoad = true
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
            initialEmptyState = favorites.isEmpty ? .noSaved : nil
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
            initialEmptyState = favorites.isEmpty ? .noSaved : nil
        } catch {
            if favorites.isEmpty {
                initialEmptyState = determineEmptyState(for: error)
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
            initialEmptyState = favorites.isEmpty ? .noSearchResults : nil
        } catch {
            if favorites.isEmpty {
                initialEmptyState = determineEmptyState(for: error)
            }
        }
        
        isLoadingInitial = false
    }
    
    private func determineEmptyState(for error: Error) -> EmptyState {
        if !NetworkMonitor.shared.isConnected {
            return .noConnection
        }
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet || urlError.code == .dataNotAllowed {
            return .noConnection
        }
        if let networkError = error as? NetworkError, case .noInternet = networkError {
            return .noConnection
        }
        return .serverProblem
    }
    
    // MARK: - Remove Favorite

    func removeFavorite(scanId: String) -> Bool {
        guard NetworkMonitor.shared.isConnected else { return false }
        
        guard let index = favorites.firstIndex(where: { $0.id == scanId }) else { return true }
        let previousEmptyState = initialEmptyState
        let removed = favorites.remove(at: index)
        if favorites.isEmpty {
            initialEmptyState = .noSaved
        }

        Task {
            do {
                try await favoritesUseCase.removeFavorite(scanId: scanId)
                notifier.setNeedsRefresh()
            } catch {
                await MainActor.run {
                    self.favorites.insert(removed, at: min(index, self.favorites.count))
                    self.initialEmptyState = previousEmptyState
                }
                print("Error removing favorite: \(error)")
            }
        }
        return true
    }

    // MARK: - Add to Daily Meals

    /// Calls POST to add the product, or PUT to increment if it already exists.
    func addMealToDaily(scanId: String, completion: @escaping (Bool) -> Void) {
        guard !addingMealIds.contains(scanId) else { return }
        
        // Fast-fail if there is no active internet connection
        guard NetworkMonitor.shared.isConnected else {
            addMealError = "No internet connection"
            completion(false)
            return
        }
        
        addingMealIds.insert(scanId)
        addMealError = nil
        lastAddedMealScanId = nil

        Task {
            do {
                try await addMealUseCase.execute(scanId: scanId)
                await MainActor.run {
                    self.lastAddedMealScanId = scanId
                    self.addingMealIds.remove(scanId)
                    completion(true)
                }
            } catch {
                let isOffline: Bool = {
                    if let networkError = error as? NetworkError {
                        if case .noInternet = networkError { return true }
                        if case .unknown(let underlying) = networkError,
                           let urlError = underlying as? URLError,
                           urlError.code == .notConnectedToInternet || urlError.code == .dataNotAllowed {
                            return true
                        }
                    }
                    if let urlError = error as? URLError,
                       urlError.code == .notConnectedToInternet || urlError.code == .dataNotAllowed {
                        return true
                    }
                    return false
                }()
                
                await MainActor.run {
                    if isOffline {
                        self.addMealError = "No internet connection"
                    } else {
                        self.addMealError = error.localizedDescription
                    }
                    self.addingMealIds.remove(scanId)
                    completion(false)
                }
            }
        }
    }
}
