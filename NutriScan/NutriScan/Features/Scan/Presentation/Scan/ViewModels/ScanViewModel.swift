import Foundation
import SwiftUI

@MainActor
final class ScanViewModel: ObservableObject {

    @Published private(set) var capturedImageData: Data?
    @Published private(set) var latestScan: ScanSubmission?
    @Published private(set) var scanDetail: ScanDetail?
    @Published private(set) var isSubmitting: Bool = false
    @Published private(set) var isLoadingDetail: Bool = false
    @Published private(set) var isSaved: Bool = false
    @Published private(set) var detectedBarcode: String?
    @Published private(set) var barcodePosition: CGPoint?
    @Published private(set) var barcodeSize: CGSize = .zero
    @Published var errorMessage: String?
    @Published var isGalleryPresented = false

    private let submitScanImageUseCase: SubmitScanImageUseCase
    private let submitBarcodeScanUseCase: SubmitBarcodeScanUseCase
    private let fetchScanDetailUseCase: FetchScanDetailUseCase
    private var pendingLostTask: Task<Void, Never>?

    nonisolated init(
        submitScanImageUseCase: SubmitScanImageUseCase,
        submitBarcodeScanUseCase: SubmitBarcodeScanUseCase,
        fetchScanDetailUseCase: FetchScanDetailUseCase
    ) {
        self.submitScanImageUseCase = submitScanImageUseCase
        self.submitBarcodeScanUseCase = submitBarcodeScanUseCase
        self.fetchScanDetailUseCase = fetchScanDetailUseCase
    }

    nonisolated static func makeDefault() -> ScanViewModel {
        ScanViewModel(
            submitScanImageUseCase: DIContainer.shared.resolve(type: SubmitScanImageUseCase.self),
            submitBarcodeScanUseCase: DIContainer.shared.resolve(type: SubmitBarcodeScanUseCase.self),
            fetchScanDetailUseCase: DIContainer.shared.resolve(type: FetchScanDetailUseCase.self)
        )
    }

    // MARK: - Barcode Detection

    func onBarcodeDetected(_ barcode: String, at position: CGPoint, size: CGSize) {
        guard !isSubmitting else { return }
        pendingLostTask?.cancel()
        detectedBarcode = barcode
        barcodePosition = position
        barcodeSize = size
    }

    func lookupByBarcode() {
        guard let barcode = detectedBarcode, !isSubmitting else { return }
        capturedImageData = nil
        isSubmitting = true
        isSaved = false
        barcodePosition = nil
        barcodeSize = .zero

        Task {
            do {
                let submission = try await submitBarcodeScanUseCase.execute(barcode: barcode)
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    latestScan = submission
                }
                isSubmitting = false
                await pollScanDetail(scanId: submission.scanId, notifyHistoryOnCompletion: true)
            } catch let error as ScanError {
                isSubmitting = false
                errorMessage = error.userMessage
            } catch {
                isSubmitting = false
                errorMessage = ScanError.unknown.userMessage
            }
        }
    }

    func scheduleDismissBarcode() {
        pendingLostTask?.cancel()
        pendingLostTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            guard !Task.isCancelled else { return }
            dismissBarcode()
        }
    }

    func dismissBarcode() {
        pendingLostTask?.cancel()
        detectedBarcode = nil
        barcodePosition = nil
        barcodeSize = .zero
    }

    // MARK: - Photo Capture

    func presentGallery() {
        isGalleryPresented = true
    }

    func onPhotoCaptured(_ imageData: Data) {
        guard !isSubmitting else { return }
        capturedImageData = imageData
        isSubmitting = true
        isSaved = false
        detectedBarcode = nil
        barcodeSize = .zero

        Task {
            do {
                let submission = try await submitScanImageUseCase.execute(imageData: imageData)
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    latestScan = submission
                }
                isSubmitting = false
                await pollScanDetail(scanId: submission.scanId, notifyHistoryOnCompletion: true)
            } catch let error as ScanError {
                isSubmitting = false
                errorMessage = error.userMessage
            } catch {
                isSubmitting = false
                errorMessage = ScanError.unknown.userMessage
            }
        }
    }

    func toggleSaveFavorite() {
        isSaved.toggle()
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
        pendingLostTask?.cancel()
        capturedImageData = nil
        latestScan = nil
        scanDetail = nil
        isSaved = false
        detectedBarcode = nil
        barcodePosition = nil
        barcodeSize = .zero
    }

    private func pollScanDetail(
        scanId: String,
        notifyHistoryOnCompletion: Bool = false
    ) async {
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
                    if notifyHistoryOnCompletion, detail.status == .completed {
                        HomeRecentHistoryNotifier.shared.setNeedsRefresh()
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
