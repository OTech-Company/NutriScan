import SwiftUI

enum ProductMatchStatus {
    case processing
    case safe
    case unsafe
}

struct ProductMatchCard: View {
    let status: ProductMatchStatus
    let imageData: Data?
    let productName: String?
    let brandName: String?
    let scanSummary: String?
    var isSaved: Bool = false
    var onSave: (() -> Void)?
    var onRetry: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            productThumbnail

            VStack(alignment: .leading, spacing: 4) {
                if let brand = brandName {
                    Text(brand.uppercased())
                        .font(.custom("LexendDeca-Medium", size: 11))
                        .foregroundColor(Color.Teal.teal400)
                }

                Text(displayTitle)
                    .font(.custom("PlusJakartaSans-Bold", size: 17))
                    .foregroundColor(.white)
                    .lineLimit(1)

                statusBadge
            }

            Spacer()

            trailingAction
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Teal.teal800.opacity(0.92))
        )
        .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
    }

    @ViewBuilder
    private var productThumbnail: some View {
        if let imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Teal.teal600.opacity(0.4))
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: "cart.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color.Teal.teal400)
                )
        }
    }

    private var displayTitle: String {
        switch status {
        case .processing:
            return productName ?? LocalizationKeys.Scan.analyzing.localized
        case .safe:
            return productName ?? scanSummary ?? LocalizationKeys.Scan.scanComplete.localized
        case .unsafe:
            return productName ?? scanSummary ?? LocalizationKeys.Scan.scanComplete.localized
        }
    }

    private var statusBadge: some View {
        Text(status.rawValue)
            .font(.custom("LexendDeca-Medium", size: 12))
            .foregroundColor(badgeTextColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(badgeColor)
            .clipShape(Capsule())
    }

    // MARK: - Dynamic Colors
    
    private var badgeTextColor: Color {
        switch status {
        case .processing: return Color(red: 0.1, green: 0.2, blue: 0.25) // Dark color for contrast against yellow
        case .safe, .unsafe: return .white
        }
    }

    private var badgeColor: Color {
        switch status {
        case .processing: return .yellow
        case .safe, .unsafe: return Color.Teal.teal400 // Brighter cyan to match image
        }
    }

    @ViewBuilder
    private var trailingAction: some View {
        switch status {
        case .processing:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.Teal.teal400))
                .frame(width: 48, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.15)) // Darker container for the spinner
                )

        case .safe, .unsafe:
            // The favorite button is only rendered when a save handler exists
            // (i.e. the scan actually succeeded). Failed scans show no button.
            if onSave != nil {
                Button {
                    onSave?()
                } label: {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.Teal.teal400)
                        )
                }
            }
        }
    }
}

extension ProductMatchStatus {
    var rawValue: String {
        switch self {
        case .processing: return LocalizationKeys.Scan.processing.localized
        case .safe:       return LocalizationKeys.Scan.safe.localized
        case .unsafe:     return LocalizationKeys.Scan.unsafe.localized
        }
    }
}
