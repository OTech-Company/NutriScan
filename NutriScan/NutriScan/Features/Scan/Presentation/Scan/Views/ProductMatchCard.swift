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

    // MARK: - Product Thumbnail

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

    // MARK: - Display Title

    private var displayTitle: String {
        switch status {
        case .processing:
            return productName ?? "Analyzing..."
        case .safe:
            return productName ?? scanSummary ?? "Scan Complete"
        case .unsafe:
            return productName ?? scanSummary ?? "Scan Complete"
        }
    }

    // MARK: - Status Badge

    private var statusBadge: some View {
        Text(status.rawValue.capitalized)
            .font(.custom("LexendDeca-Medium", size: 12))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(badgeColor)
            .clipShape(Capsule())
    }

    private var badgeColor: Color {
        switch status {
        case .processing: return .orange
        case .safe:       return Color.Teal.teal700
        case .unsafe:     return Color.Teal.teal700
        }
    }

    // MARK: - Trailing Action

    @ViewBuilder
    private var trailingAction: some View {
        switch status {
        case .processing:
            ProgressView()
                .tint(.white)
                .frame(width: 48, height: 48)

        case .safe:
            Button {
                onSave?()
            } label: {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.Teal.teal700)
                    )
            }

        case .unsafe:
            Button {
                onSave?()
            } label: {
                Image(systemName: "bookmark")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.Teal.teal700)
                    )
            }
        }
    }
}

// MARK: - ProductMatchStatus RawValue

extension ProductMatchStatus {
    var rawValue: String {
        switch self {
        case .processing: return "Processing"
        case .safe:       return "Safe"
        case .unsafe:     return "Unsafe"
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        ProductMatchCard(status: .processing, imageData: nil, productName: "Milk Nature", brandName: "FANMILK", scanSummary: nil)
        ProductMatchCard(status: .unsafe, imageData: nil, productName: "Milk Nature", brandName: "FANMILK", scanSummary: "Contains flagged additives")
        ProductMatchCard(status: .safe, imageData: nil, productName: "Milk Nature", brandName: "FANMILK", scanSummary: "All ingredients safe")
    }
    .padding()
    .background(Color.black)
}
