import Foundation
import Observation

@Observable
final class HomeViewModel {

    private let fetchScansUseCase: FetchScansUseCase

    var userName: String = "Youssef"
    var dailyTip: String = "Stay hydrated! Drink at least 8 glasses of water today."
    var recentHistory: [UiStateHistoryItem] = []
    var isLoadingHistory = false

    init(fetchScansUseCase: FetchScansUseCase = DIContainer.shared.resolve(type: FetchScansUseCase.self)) {
        self.fetchScansUseCase = fetchScansUseCase
    }

    func loadHistory() {
        guard !isLoadingHistory else { return }
        isLoadingHistory = true
        Task {
            do {
                let page = try await fetchScansUseCase.execute(page: 0, size: 10)
                recentHistory = page.content.map { $0.toHistoryItem() }
            } catch {
                recentHistory = []
            }
            isLoadingHistory = false
        }
    }
}

// MARK: - Mapping

private extension ScanListItem {

    func toHistoryItem() -> UiStateHistoryItem {
        UiStateHistoryItem(
            id: scanId,
            title: "Scanned Product",
            scannedAt: Self.relativeDateString(from: scannedAt),
            imageName: imageUrl,
            status: verdict.toStatusType()
        )
    }

    private static func relativeDateString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .hour, .minute], from: date, to: now)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"

        let timeString = timeFormatter.string(from: date)

        if let days = components.day, days == 0 {
            return "Today, \(timeString)"
        } else if let days = components.day, days == 1 {
            return "Yesterday, \(timeString)"
        } else if let days = components.day, days > 1 {
            return "\(days) days ago, \(timeString)"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            return formatter.string(from: date)
        }
    }
}

private extension ScanResultVerdict {

    func toStatusType() -> StatusType {
        switch self {
        case .safe: return .safe
        case .unsafe: return .unsafe
        case .caution, .unknown: return .caution
        }
    }
}
