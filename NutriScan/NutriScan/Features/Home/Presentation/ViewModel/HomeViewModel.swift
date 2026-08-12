import Foundation
import Observation

@Observable
final class HomeRecentHistoryNotifier {
    static let shared = HomeRecentHistoryNotifier()

    private(set) var refreshToken = UUID()

    private init() {}

    func setNeedsRefresh() {
        refreshToken = UUID()
    }
}

@Observable
final class HomeViewModel {

    private static let recentHistoryLimit = 5

    private let scanHistoryUseCase: ScanHistoryUseCaseProtocol
    private let observeProfileUseCase: ObserveProfileUseCaseProtocol

    var dailyTip: String = "Stay hydrated! Drink at least 8 glasses of water today."
    var recentHistory: [UiStateHistoryItem] = []
    var isLoadingHistory = false

    private var hasLoadedHistory = false

    // MARK: - Reactive Profile Data
    var userName: String {
        let profile = observeProfileUseCase.execute().currentProfile
        return profile?.firstName ?? "User"
    }

    var userImageURL: String? {
        observeProfileUseCase.execute().currentProfile?.imageUrl
    }

    init(
        scanHistoryUseCase: ScanHistoryUseCaseProtocol = DIContainer.shared.resolve(type: ScanHistoryUseCaseProtocol.self),
        observeProfileUseCase: ObserveProfileUseCaseProtocol = DIContainer.shared.resolve(type: ObserveProfileUseCaseProtocol.self)
    ) {
        self.scanHistoryUseCase = scanHistoryUseCase
        self.observeProfileUseCase = observeProfileUseCase
    }

    func loadHistoryIfNeeded() async {
        guard !hasLoadedHistory else { return }
        await loadHistory()
    }

    func refreshHistory() async {
        await loadHistory()
    }

    private func loadHistory() async {
        guard !isLoadingHistory else { return }
        isLoadingHistory = true
        defer {
            isLoadingHistory = false
            hasLoadedHistory = true
        }

        do {
            var completedScans: [ScanHistoryEntity] = []
            var currentPage = 0
            var totalPages = 1

            repeat {
                let result = try await scanHistoryUseCase.getScanHistory(
                    page: currentPage,
                    size: Self.recentHistoryLimit
                )

                completedScans.append(
                    contentsOf: result.scans.filter { $0.scanStatus == .completed }
                )
                totalPages = result.totalPages
                currentPage += 1
            } while completedScans.count < Self.recentHistoryLimit && currentPage < totalPages

            recentHistory = completedScans
                .prefix(Self.recentHistoryLimit)
                .map { $0.toHistoryItem() }
        } catch {
            recentHistory = []
        }
    }
}

// MARK: - Mapping

private extension ScanHistoryEntity {

    func toHistoryItem() -> UiStateHistoryItem {
        UiStateHistoryItem(
            id: id,
            title: productName,
            scannedAt: Self.relativeDateString(from: scannedAt),
            imageName: imageUrl,
            status: status
        )
    }

    private static func relativeDateString(from dateString: String) -> String {
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
