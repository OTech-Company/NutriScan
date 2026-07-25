import Foundation

@MainActor
final class ProductDetailViewModel: ObservableObject {

    @Published private(set) var scanDetail: ScanDetail?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    let scanId: String
    private let fetchScanDetailUseCase: FetchScanDetailUseCase

    nonisolated init(
        scanId: String,
        fetchScanDetailUseCase: FetchScanDetailUseCase = DIContainer.shared.resolve(type: FetchScanDetailUseCase.self)
    ) {
        self.scanId = scanId
        self.fetchScanDetailUseCase = fetchScanDetailUseCase
    }

    func loadIfNeeded() {
        guard scanDetail == nil, !isLoading else { return }
        Task { await load() }
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            scanDetail = try await fetchScanDetailUseCase.execute(scanId: scanId)
        } catch let error as ScanError {
            errorMessage = error.userMessage
        } catch {
            errorMessage = ScanError.unknown.userMessage
        }
    }
}
