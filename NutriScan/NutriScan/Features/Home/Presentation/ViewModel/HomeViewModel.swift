import Foundation
import Observation

@Observable
final class HomeViewModel {

    private let fetchScansUseCase: FetchScansUseCase
    private let observeProfileUseCase: ObserveProfileUseCaseProtocol

    var dailyTip: String = "Stay hydrated! Drink at least 8 glasses of water today."
    var recentHistory: [UiStateHistoryItem] = []
    var isLoadingHistory = false

    // MARK: - Reactive Profile Data
    var userName: String {
        let profile = observeProfileUseCase.execute().currentProfile
        return profile?.firstName ?? "User"
    }

    var userImageURL: String? {
        observeProfileUseCase.execute().currentProfile?.imageUrl
    }

    init(
        fetchScansUseCase: FetchScansUseCase = DIContainer.shared.resolve(type: FetchScansUseCase.self),
        observeProfileUseCase: ObserveProfileUseCaseProtocol = DIContainer.shared.resolve(type: ObserveProfileUseCaseProtocol.self)
    ) {
        self.fetchScansUseCase = fetchScansUseCase
        self.observeProfileUseCase = observeProfileUseCase
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
