import SwiftUI

/// Bottom card that displays scan state: processing, result, or failed.
struct ScanStateCardView: View {
    let isSubmitting: Bool
    let latestScan: ScanSubmission?
    let isLoadingDetail: Bool
    let scanDetail: ScanDetail?
    let capturedImageData: Data?
    var onSave: () -> Void
    var onRetry: () -> Void
    var onTapDetail: (String) -> Void

    var body: some View {
        if isSubmitting {
            processingCard
        } else if let scan = latestScan {
            if isLoadingDetail {
                processingCard
            } else if let detail = scanDetail {
                switch detail.status {
                case .completed:
                    resultCard(detail: detail, scanId: scan.scanId)
                case .failed:
                    failedCard
                default:
                    processingCard
                }
            } else {
                processingCard
            }
        }
    }

    // MARK: - Processing Card

    private var processingCard: some View {
        ProductMatchCard(
            status: .processing,
            imageData: capturedImageData,
            productName: nil,
            brandName: nil,
            scanSummary: nil
        )
    }

    // MARK: - Result Card

    private func resultCard(detail: ScanDetail, scanId: String) -> some View {
        let status: ProductMatchStatus = {
            switch detail.foodSafetyResponse?.verdict {
            case .safe:  return .safe
            case .unsafe, .caution: return .unsafe
            default:     return .processing
            }
        }()

        return ProductMatchCard(
            status: status,
            imageData: capturedImageData,
            productName: detail.productName,
            brandName: nil,
            scanSummary: detail.foodSafetyResponse?.summary,
            onSave: onSave
        )
        .onTapGesture {
            onTapDetail(scanId)
        }
    }

    // MARK: - Failed Card

    private var failedCard: some View {
        ProductMatchCard(
            status: .unsafe,
            imageData: capturedImageData,
            productName: "Scan Failed",
            brandName: nil,
            scanSummary: "Could not analyze product",
            onRetry: onRetry
        )
        .onTapGesture {
            onRetry()
        }
    }
}
