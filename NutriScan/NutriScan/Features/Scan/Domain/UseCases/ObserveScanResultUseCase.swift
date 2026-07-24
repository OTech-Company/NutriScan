import Foundation

protocol ObserveScanResultUseCase {
    func execute(scanId: String) -> AsyncThrowingStream<ScanResult, Error>
}

final class ObserveScanResultUseCaseImpl: ObserveScanResultUseCase {

    private let repository: ScanRepository

    init(repository: ScanRepository) {
        self.repository = repository
    }

    func execute(scanId: String) -> AsyncThrowingStream<ScanResult, Error> {
        repository.observeScanResult(scanId: scanId)
    }
}
