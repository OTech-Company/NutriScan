//
//  ScanHistoryViewModel.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class ScanHistoryViewModel {
    var scans: [ScanHistoryEntity] = []
    var isLoadingInitial: Bool = false
    var isLoadingNextPage: Bool = false
    var isRefreshing: Bool = false

    // MARK: - Search State
    var isSearching: Bool = false
    var searchEmptyState: EmptyState? = nil
    private var allScans: [ScanHistoryEntity] = []
    private(set) var isInSearchMode: Bool = false
    
    /// Non-nil only when the very first fetch (page 0) fails and the list is empty.
    var initialLoadEmptyState: EmptyState? = nil
    /// Non-nil when a subsequent page fetch fails — shown as an inline footer.
    var paginationError: String? = nil
    var deleteErrorMessage: String? = nil
    
    private var currentPage: Int = 0
    private var hasMorePages: Bool = true
    private let pageSize: Int = 20
    
    let scanHistoryUseCase: ScanHistoryUseCaseProtocol
    
    init(scanHistoryUseCase: ScanHistoryUseCaseProtocol) {
        self.scanHistoryUseCase = scanHistoryUseCase
    }
    
    // MARK: - Public API
    
    /// Only fetches if data is empty and there's no previous error.
    func loadScanHistoryIfNeeded() async {
        guard scans.isEmpty && initialLoadEmptyState == nil else { return }
        await loadScanHistory()
    }
    
    /// Initial load — resets pagination and fetches page 0.
    func loadScanHistory() async {
        currentPage = 0
        hasMorePages = true
        initialLoadEmptyState = nil
        paginationError = nil
        isLoadingInitial = true
        scans.removeAll()
        
        await fetchPage()
    }
    
    /// Pull-to-refresh — keeps existing data if the refresh fails.
    func refreshScanHistory() async {
        isRefreshing = true
        paginationError = nil
        
        let previousScans = scans
        let previousPage = currentPage
        let previousHasMore = hasMorePages
        
        currentPage = 0
        hasMorePages = true
        
        do {
            let result = try await scanHistoryUseCase.getScanHistory(page: 0, size: pageSize)
            scans = result.scans
            currentPage = 1
            hasMorePages = currentPage < result.totalPages
            initialLoadEmptyState = nil
        } catch {
            // Failure — restore previous data
            scans = previousScans
            currentPage = previousPage
            hasMorePages = previousHasMore
        }
        
        isRefreshing = false
    }
    
    /// Triggered by onAppear of the last item in the list.
    func loadNextPageIfNeeded(currentItem: ScanHistoryEntity) {
        guard let lastItem = scans.last, lastItem.id == currentItem.id else { return }
        guard !isLoadingNextPage && !isLoadingInitial && hasMorePages else { return }
        guard paginationError == nil else { return }
        
        Task {
            await fetchNextPage()
        }
    }
    
    /// Retry loading the next page after a pagination error.
    func retryPagination() {
        paginationError = nil
        Task {
            await fetchNextPage()
        }
    }

    // MARK: - Search

    /// Searches scan history using the suggestions endpoint, then filters the displayed list.
    func searchScans(query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            clearSearch()
            return
        }

        // Fast-fail if offline — never show stale cached results or a misleading
        // "No results found" state when the real problem is no connectivity.
        guard NetworkMonitor.shared.isConnected else {
            isInSearchMode = true
            isSearching = false
            searchEmptyState = .noConnection
            return
        }

        isInSearchMode = true
        isSearching = true
        searchEmptyState = nil

        // Snapshot the full list so we can filter it (and restore it on clear)
        if allScans.isEmpty {
            allScans = scans
        }

        do {
            let matchingNames = try await scanHistoryUseCase.getSuggestions(query: trimmed)
            let nameSet = Set(matchingNames.map { $0.lowercased() })
            let filtered = allScans.filter { nameSet.contains($0.productName.lowercased()) }
            scans = filtered
            searchEmptyState = filtered.isEmpty ? .noSearchResults : nil
        } catch {
            if isNetworkError(error) {
                // Connection dropped mid-request — restore list and show no-connection
                scans = allScans
                searchEmptyState = .noConnection
            } else {
                // Non-network failure (e.g. decoding): surface as a server error
                scans = allScans
                searchEmptyState = .serverProblem
            }
        }

        isSearching = false
    }

    // MARK: - Helpers

    private func isNetworkError(_ error: Error) -> Bool {
        if !NetworkMonitor.shared.isConnected { return true }
        if let urlError = error as? URLError,
           urlError.code == .notConnectedToInternet || urlError.code == .dataNotAllowed {
            return true
        }
        if let networkError = error as? NetworkError, case .noInternet = networkError {
            return true
        }
        return false
    }

    private func determineInitialEmptyState(for error: Error) -> EmptyState {
        return isNetworkError(error) ? .noConnection : .serverProblem
    }

    /// Clears the active search and restores the full scan list.
    func clearSearch() {
        isInSearchMode = false
        isSearching = false
        searchEmptyState = nil
        if !allScans.isEmpty {
            scans = allScans
            allScans = []
        }
    }

    func deleteScan(_ scan: ScanHistoryEntity) async {
        let previousScans = scans
        withAnimation(.spring(response: 0.28, dampingFraction: 0.85)) {
            scans.removeAll { $0.id == scan.id }
        }
        deleteErrorMessage = nil

        do {
            try await scanHistoryUseCase.deleteScan(scanId: scan.id)
            HomeRecentHistoryNotifier.shared.setNeedsRefresh()
        } catch {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.85)) {
                scans = previousScans
            }
            deleteErrorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Private Fetch Methods
    
    private func fetchPage() async {
        do {
            let result = try await scanHistoryUseCase.getScanHistory(page: 0, size: pageSize)
            scans = result.scans
            currentPage = 1
            hasMorePages = currentPage < result.totalPages
            initialLoadEmptyState = nil
        } catch {
            if scans.isEmpty {
                initialLoadEmptyState = determineInitialEmptyState(for: error)
            }
        }
        
        isLoadingInitial = false
    }
    
    private func fetchNextPage() async {
        guard !isLoadingNextPage && hasMorePages else { return }
        isLoadingNextPage = true
        paginationError = nil
        
        do {
            let result = try await scanHistoryUseCase.getScanHistory(page: currentPage, size: pageSize)
            scans.append(contentsOf: result.scans)
            currentPage += 1
            hasMorePages = currentPage < result.totalPages
        } catch {
            paginationError = error.localizedDescription
        }
        
        isLoadingNextPage = false
    }
    
    // MARK: - Helpers
    
    /// Formats an ISO 8601 date string into a relative, human-readable format
    /// matching the style used in the Home screen (e.g. "Today, 9:24 AM")
    func formatDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        var date = isoFormatter.date(from: dateString)
        if date == nil {
            isoFormatter.formatOptions = [.withInternetDateTime]
            date = isoFormatter.date(from: dateString)
        }
        
        guard let parsedDate = date else { return dateString }
        
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .hour, .minute], from: parsedDate, to: now)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: parsedDate)
        
        if let days = components.day, days == 0 {
            return "\(LocalizationKeys.ScanHistory.today.localized), \(timeString)"
        } else if let days = components.day, days == 1 {
            return "\(LocalizationKeys.ScanHistory.yesterday.localized), \(timeString)"
        } else if let days = components.day, days > 1 {
            return "\(days) days ago, \(timeString)"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            return formatter.string(from: parsedDate)
        }
    }
}
