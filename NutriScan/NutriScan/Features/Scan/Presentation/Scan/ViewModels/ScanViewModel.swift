import Foundation
import SwiftUI

@MainActor
final class ScanViewModel: ObservableObject {

    @Published private(set) var latestScan: ScanSubmission?
    @Published private(set) var scanDetail: ScanDetail?
    @Published private(set) var isSubmitting: Bool = false
    @Published private(set) var isLoadingDetail: Bool = false
    @Published var errorMessage: String?

    private let submitScanImageUseCase: SubmitScanImageUseCase
    private let fetchScanDetailUseCase: FetchScanDetailUseCase

    nonisolated init(
        submitScanImageUseCase: SubmitScanImageUseCase,
        fetchScanDetailUseCase: FetchScanDetailUseCase
    ) {
        self.submitScanImageUseCase = submitScanImageUseCase
        self.fetchScanDetailUseCase = fetchScanDetailUseCase
    }

    nonisolated static func makeDefault() -> ScanViewModel {
        ScanViewModel(
            submitScanImageUseCase: DIContainer.shared.resolve(type: SubmitScanImageUseCase.self),
            fetchScanDetailUseCase: DIContainer.shared.resolve(type: FetchScanDetailUseCase.self)
        )
    }

    func onPhotoCaptured(_ imageData: Data) {
        guard !isSubmitting else { return }
        isSubmitting = true

        Task {
            do {
                let submission = try await submitScanImageUseCase.execute(imageData: imageData)
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    latestScan = submission
                }
                isSubmitting = false
                await pollScanDetail(scanId: submission.scanId)
            } catch let error as ScanError {
                isSubmitting = false
                errorMessage = error.userMessage
            } catch {
                isSubmitting = false
                errorMessage = ScanError.unknown.userMessage
            }
        }
    }

    func loadScanDetail(scanId: String) {
        guard scanDetail == nil, !isLoadingDetail else { return }
        Task {
            await pollScanDetail(scanId: scanId)
        }
    }

    func dismissError() {
        errorMessage = nil
    }

    func reset() {
        latestScan = nil
        scanDetail = nil
    }

    private func pollScanDetail(scanId: String) async {
        isLoadingDetail = true
        defer { isLoadingDetail = false }

        var attempts = 0
        let maxAttempts = 30

        while attempts < maxAttempts {
            do {
                let detail = try await fetchScanDetailUseCase.execute(scanId: scanId)
                if detail.status == .completed || detail.status == .failed {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                        scanDetail = detail
                    }
                    return
                }
            } catch {
                break
            }
            attempts += 1
            try? await Task.sleep(for: .seconds(1))
        }

        errorMessage = ScanError.unknown.userMessage
    }
}
