import SwiftUI

struct ProductHeaderSection: View {
    let state: ProductHeaderUIState

    private var displayTitle: String {
        state.productName
    }

    private var titleFont: Font {
        let wordCount = state.productName.split(separator: " ").count
        if wordCount <= 1 {
            return Font.AppFont.title1
        } else {
            return Font.AppFont.title1
        }
    }

    private var titleLineLimit: Int? {
        let wordCount = state.productName.split(separator: " ").count
        if wordCount > 6 {
            return 3
        } else if wordCount > 3 {
            return 2
        }
        return nil
    }

    private var formattedDate: String {
        let raw = state.scannedAt
        // Check if it's already formatted (not ISO8601)
        if raw.contains("T") && raw.contains("Z") {
            // Raw ISO8601 — format it
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = isoFormatter.date(from: raw) {
                let display = DateFormatter()
                display.dateFormat = "MMM d, yyyy 'at' h:mm a"
                return display.string(from: date)
            }
            // Try without fractional seconds
            isoFormatter.formatOptions = [.withInternetDateTime]
            if let date = isoFormatter.date(from: raw) {
                let display = DateFormatter()
                display.dateFormat = "MMM d, yyyy 'at' h:mm a"
                return display.string(from: date)
            }
            return raw
        }
        return raw
    }

    var body: some View {
        VStack(spacing: 16) {
            CachedImage(
                urlString: state.imageUrl,
                failureImageName: "",
                contentMode: .fill
            )
            .frame(maxWidth: .infinity, minHeight: 192, maxHeight: 192)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(Color.Teal.teal1000, style: StrokeStyle(lineWidth: 3))
            }

            HStack(alignment: .bottom, spacing: 12) {
                Text(displayTitle)
                    .font(titleFont)
                    .lineLimit(titleLineLimit)
                    .minimumScaleFactor(0.85)
                    .foregroundStyle(Color(light: Color.Teal.teal1000, dark: Color.Teal.teal400))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
                Spacer()
                VStack(alignment: .center, spacing: 0) {
                    Text(LocalizationKeys.ProductDetails.scannedAt.localized)
                        .foregroundStyle(Color(light: Color.Gray.gray500, dark: Color.Teal.teal1300))
                        .font(Font.AppFont.textSecondary.weight(.bold))
                    Text(formattedDate)
                        .foregroundStyle(Color.Teal.teal800)
                        .font(Font.AppFont.textSecondary.weight(.bold))
                        .padding(.horizontal, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(Color.Teal.teal200)
                        }
                }
                .fixedSize()
            }
        }
    }
}

#Preview {
    ProductHeaderSection(state: ProductDetailsUIState.mock.headerState)
        .padding()
}
