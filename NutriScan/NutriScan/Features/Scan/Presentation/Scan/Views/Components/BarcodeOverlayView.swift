import SwiftUI

/// Floating pill button that appears over a detected barcode location.
struct BarcodeOverlayView: View {
    let barcode: String
    let barcodeSize: CGSize
    var onTap: () -> Void

    /// Scale factor based on barcode width relative to a reference width (140pt).
    private var scale: CGFloat {
        let referenceWidth: CGFloat = 140
        let rawScale = barcodeSize.width / referenceWidth
        return min(max(rawScale, 0.7), 1.4)
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6 * scale) {
                Image(systemName: "barcode.viewfinder")
                    .font(.system(size: 14 * scale, weight: .semibold))
                Text(barcode)
                    .font(.system(size: 13 * scale, weight: .medium, design: .monospaced))
                    .lineLimit(1)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 14 * scale)
            .padding(.vertical, 10 * scale)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(Color.Teal.teal1000.opacity(0.6), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        }
        .transition(.scale.combined(with: .opacity))
    }
}
