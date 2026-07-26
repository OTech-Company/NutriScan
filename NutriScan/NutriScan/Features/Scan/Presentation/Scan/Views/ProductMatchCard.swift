import SwiftUI

struct ProductMatchCard: View {
    let detail: ScanDetail
    var onAdd: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            productImage

            VStack(alignment: .leading, spacing: 2) {
                Text(detail.foodSafetyResponse?.verdict.rawValue ?? "Processing")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                Text(detail.foodSafetyResponse?.summary ?? "Analyzing...")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }

            Spacer()

            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.teal)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .accessibilityLabel("View scan details")
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
    }

    @ViewBuilder
    private var productImage: some View {
        if let url = detail.imageUrl, let imageURL = URL(string: url) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFit()
                default:
                    Color(.systemGray6)
                }
            }
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
                .frame(width: 48, height: 48)
        }
    }
}
