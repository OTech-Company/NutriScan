import SwiftUI

/// Bottom card that displays scan state: processing, result, or failed.
struct ScanStateCardView: View {
    let isSubmitting: Bool
    let latestScan: ScanSubmission?
    let isLoadingDetail: Bool
    let scanDetail: ScanDetail?
    let capturedImageData: Data?
    var isSaved: Bool = false
    var onSave: () -> Void
    var onRetry: () -> Void
    var onTapDetail: (ScanDetail) -> Void

    var body: some View {
        if isSubmitting {
            processingCard
        } else if let scan = latestScan {
            if isLoadingDetail {
                processingCard
            } else if let detail = scanDetail {
                switch detail.status {
                case .completed:
                    resultCard(detail: detail)
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

    private var processingCard: some View {
        ProductMatchCard(
            status: .processing,
            imageData: capturedImageData,
            productName: nil,
            brandName: nil,
            scanSummary: nil
        )
    }

    private func resultCard(detail: ScanDetail) -> some View {
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
            isSaved: isSaved,
            onSave: onSave
        )
        .onTapGesture {
            onTapDetail(detail)
        }
    }

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
