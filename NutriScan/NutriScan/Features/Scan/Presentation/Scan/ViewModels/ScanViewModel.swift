import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class ScanViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case capturing
        case uploading
        case processing
        case result
    }

    @Published var state: State = .idle
    @Published var capturedImage: UIImage?
    @Published var scanResult: ScanResult?
    @Published var errorMessage: String?
    @Published var showGallery = false
    @Published var gallerySelection: PhotosPickerItem? {
        didSet {
            guard let item = gallerySelection else { return }
            Task { await loadGalleryImage(item) }
        }
    }

    let cameraManager = CameraManager()

    private let uploadScanUseCase: UploadScanUseCase
    private let observeScanResultUseCase: ObserveScanResultUseCase
    private var currentScanId: String?

    nonisolated init(
        uploadScanUseCase: UploadScanUseCase,
        observeScanResultUseCase: ObserveScanResultUseCase
    ) {
        self.uploadScanUseCase = uploadScanUseCase
        self.observeScanResultUseCase = observeScanResultUseCase
    }

    nonisolated static func makeDefault() -> ScanViewModel {
        let repository = ScanRepositoryImpl()
        return ScanViewModel(
            uploadScanUseCase: UploadScanUseCaseImpl(repository: repository),
            observeScanResultUseCase: ObserveScanResultUseCaseImpl(repository: repository)
        )
    }

    func startCamera() {
        cameraManager.checkAuthorization()
    }

    func stopCamera() {
        cameraManager.stopSession()
    }

    func capturePhoto() {
        guard state == .idle else { return }
        state = .capturing
        cameraManager.capturePhoto()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self, let data = self.cameraManager.capturedImageData else {
                self?.state = .idle
                return
            }
            self.uploadAndObserve(imageData: data)
        }
    }

    func retake() {
        state = .idle
        capturedImage = nil
        scanResult = nil
        errorMessage = nil
        currentScanId = nil
        cameraManager.capturedImageData = nil
        cameraManager.startSession()
    }

    func dismissError() {
        errorMessage = nil
    }

    private func loadGalleryImage(_ item: PhotosPickerItem) async {
        guard state == .idle else { return }
        state = .capturing

        guard let data = try? await item.loadTransferable(type: Data.self) else {
            errorMessage = ScanError.emptyImage.userMessage
            state = .idle
            return
        }

        if let uiImage = UIImage(data: data) {
            capturedImage = uiImage
            cameraManager.stopSession()
        }

        uploadAndObserve(imageData: data)
    }

    private func uploadAndObserve(imageData: Data) {
        state = .uploading
        capturedImage = UIImage(data: imageData)

        Task {
            do {
                let scanId = try await uploadScanUseCase.execute(
                    imageData: imageData,
                    filename: "scan_\(UUID().uuidString).jpg"
                )
                currentScanId = scanId
                state = .processing
                observeResult(scanId: scanId)
            } catch {
                errorMessage = error.localizedDescription
                state = .idle
            }
        }
    }

    private func observeResult(scanId: String) {
        Task {
            do {
                for try await result in observeScanResultUseCase.execute(scanId: scanId) {
                    if result.verdict != .caution || result.nutritionFacts != nil {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                            scanResult = result
                            state = .result
                        }
                        return
                    }
                }
            } catch {
                await fetchResultPolling(scanId: scanId)
            }
        }
    }

    private func fetchResultPolling(scanId: String) async {
        let repository = DIContainer.shared.resolve(type: ScanRepository.self)
        let maxAttempts = 30
        let interval: UInt64 = 2_000_000_000

        for _ in 0..<maxAttempts {
            do {
                let result = try await repository.fetchScanResult(scanId: scanId)
                withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                    scanResult = result
                    state = .result
                }
                return
            } catch {
                try? await Task.sleep(nanoseconds: interval)
            }
        }

        errorMessage = ScanError.scanFailed("Timed out waiting for results.").userMessage
        state = .idle
    }
}
