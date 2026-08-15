import Foundation

protocol FetchScansUseCase {
    func execute(page: Int, size: Int) async throws -> ScanPage
}

final class FetchScansUseCaseImpl: FetchScansUseCase {

    private let repository: ScanRepository

    init(repository: ScanRepository) {
        self.repository = repository
    }

    func execute(page: Int, size: Int) async throws -> ScanPage {
        try await repository.fetchScans(page: page, size: size)
    }
}

protocol SubmitScanImageUseCase {
    func execute(imageData: Data) async throws -> ScanSubmission
}

final class SubmitScanImageUseCaseImpl: SubmitScanImageUseCase {

    private let repository: ScanRepository

    init(repository: ScanRepository) {
        self.repository = repository
    }

    func execute(imageData: Data) async throws -> ScanSubmission {
        guard !imageData.isEmpty else {
            throw ScanError.unknown
        }
        return try await repository.submitScan(imageData: imageData)
    }
}

protocol SubmitBarcodeScanUseCase {
    func execute(barcode: String) async throws -> ScanSubmission
}

final class SubmitBarcodeScanUseCaseImpl: SubmitBarcodeScanUseCase {

    private let repository: ScanRepository

    init(repository: ScanRepository) {
        self.repository = repository
    }

    func execute(barcode: String) async throws -> ScanSubmission {
        guard !barcode.isEmpty else {
            throw ScanError.unknown
        }
        return try await repository.submitBarcode(barcode: barcode)
    }
}

protocol FetchScanDetailUseCase {
    func execute(scanId: String) async throws -> ScanDetail
}

final class FetchScanDetailUseCaseImpl: FetchScanDetailUseCase {

    private let repository: ScanRepository

    init(repository: ScanRepository) {
        self.repository = repository
    }

    func execute(scanId: String) async throws -> ScanDetail {
        guard !scanId.isEmpty else {
            throw ScanError.scanNotFound(scanId: scanId)
        }
        return try await repository.fetchScanDetail(scanId: scanId)
    }
}
