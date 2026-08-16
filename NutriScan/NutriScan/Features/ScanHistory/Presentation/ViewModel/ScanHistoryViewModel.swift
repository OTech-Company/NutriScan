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
    
    /// Non-nil only when the very first fetch (page 0) fails and the list is empty.
    var initialLoadError: String? = nil
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
        guard scans.isEmpty && initialLoadError == nil else { return }
        await loadScanHistory()
    }
    
    /// Initial load — resets pagination and fetches page 0.
    func loadScanHistory() async {
        currentPage = 0
        hasMorePages = true
        initialLoadError = nil
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
            initialLoadError = nil
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
            initialLoadError = nil
        } catch {
            if scans.isEmpty {
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
