import SwiftUI

/// Bottom card shown once a barcode resolves to a product.
/// Takes the Domain `Product` entity directly — no DTOs, no view-only models.
struct ProductMatchCard: View {
    let product: Product
    var onAdd: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            productImage

            VStack(alignment: .leading, spacing: 2) {
                Text(product.brand.uppercased())
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                Text(product.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
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
            .accessibilityLabel("Add \(product.name)")
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
    }

    @ViewBuilder
    private var productImage: some View {
        if let url = product.imageURL {
            AsyncImage(url: url) { phase in
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

#Preview {
    ProductMatchCard(
        product: Product(id: "1", barcode: "123456", brand: "FANMILK",
                          name: "Milk Nature", imageURL: nil, healthTag: .healthy),
        onAdd: {}
    )
    .padding()
}
