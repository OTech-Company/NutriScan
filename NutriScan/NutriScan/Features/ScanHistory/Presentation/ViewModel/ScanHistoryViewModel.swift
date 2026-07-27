//
//  ScanHistoryViewModel.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import Foundation
import Observation

@Observable
final class ScanHistoryViewModel {
    var scans: [ScanHistoryEntity] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    private var currentPage: Int = 0
    private var hasMorePages: Bool = true
    private let pageSize: Int = 20
    
    let scanHistoryUseCase: ScanHistoryUseCaseProtocol
    
    init(scanHistoryUseCase: ScanHistoryUseCaseProtocol) {
        self.scanHistoryUseCase = scanHistoryUseCase
    }
    
    func loadScanHistory() async {
        currentPage = 0
        hasMorePages = true
        scans.removeAll()
        await fetchScanHistory()
    }
    
    func loadNextPageIfNeeded(currentItem: ScanHistoryEntity) {
        guard let lastItem = scans.last, lastItem.id == currentItem.id else { return }
        guard !isLoading && hasMorePages else { return }
        
        Task {
            await fetchScanHistory()
        }
    }
    
    func fetchScanHistory() async {
        guard !isLoading && hasMorePages else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await scanHistoryUseCase.getScanHistory(page: currentPage, size: pageSize)
            
            scans.append(contentsOf: result.scans)
            
            currentPage += 1
            hasMorePages = currentPage < result.totalPages
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
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
            return "Today, \(timeString)"
        } else if let days = components.day, days == 1 {
            return "Yesterday, \(timeString)"
        } else if let days = components.day, days > 1 {
            return "\(days) days ago, \(timeString)"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            return formatter.string(from: parsedDate)
        }
    }
}
