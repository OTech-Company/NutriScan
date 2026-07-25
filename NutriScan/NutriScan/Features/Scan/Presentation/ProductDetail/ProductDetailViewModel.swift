import Foundation

@MainActor
final class ProductDetailViewModel: ObservableObject {

    @Published private(set) var scanDetail: ScanDetail?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    let scanId: String?
    let capturedImageData: Data

    private let fetchScanDetailUseCase: FetchScanDetailUseCase?

    init(
        detail: ScanDetail,
        imageData: Data
    ) {
        self.scanId = detail.scanId
        self.capturedImageData = imageData
        self.scanDetail = detail
        self.fetchScanDetailUseCase = nil
    }

    init(
        scanId: String,
        imageData: Data,
        fetchScanDetailUseCase: FetchScanDetailUseCase = DIContainer.shared.resolve(type: FetchScanDetailUseCase.self)
    ) {
        self.scanId = scanId
        self.capturedImageData = imageData
        self.fetchScanDetailUseCase = fetchScanDetailUseCase
    }

    func loadIfNeeded() {
        guard scanDetail == nil, !isLoading, fetchScanDetailUseCase != nil else { return }
        Task { await load() }
    }

    func toggleSaveFavorite() {
        // TODO: Implement save to favorites API call
    }

    private func load() async {
        guard let scanId, let useCase = fetchScanDetailUseCase else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            scanDetail = try await useCase.execute(scanId: scanId)
        } catch let error as ScanError {
            errorMessage = error.userMessage
        } catch {
            errorMessage = ScanError.unknown.userMessage
        }
    }
}
