import Foundation

protocol UploadScanUseCase {
    func execute(imageData: Data, filename: String) async throws -> String
}

final class UploadScanUseCaseImpl: UploadScanUseCase {

    private let repository: ScanRepository

    init(repository: ScanRepository) {
        self.repository = repository
    }

    func execute(imageData: Data, filename: String) async throws -> String {
        guard !imageData.isEmpty else {
            throw ScanError.emptyImage
        }
        return try await repository.uploadScan(imageData: imageData, filename: filename)
    }
}
