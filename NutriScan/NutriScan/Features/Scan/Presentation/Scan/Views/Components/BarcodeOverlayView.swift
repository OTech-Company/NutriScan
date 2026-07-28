import SwiftUI

/// Floating pill button that appears over a detected barcode location.
struct BarcodeOverlayView: View {
    let barcode: String
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: "barcode.viewfinder")
                    .font(.system(size: 16, weight: .semibold))
                Text(barcode)
                    .font(.system(size: 15, weight: .medium, design: .monospaced))
                    .lineLimit(1)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
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
