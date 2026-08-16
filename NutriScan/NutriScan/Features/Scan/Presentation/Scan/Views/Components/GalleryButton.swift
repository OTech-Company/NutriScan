import SwiftUI

/// Gallery button shown on the top-left of the scan screen.
/// Opens the photo library so the user can pick an image to scan.
struct GalleryButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.15))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.Teal.teal1000.opacity(0.6), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        }
        .accessibilityLabel("Choose from gallery")
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        GalleryButton {}
    }
}
