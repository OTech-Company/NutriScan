import SwiftUI
import PhotosUI

struct PhotoPickerButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 16, weight: .semibold))
                Text("Gallery")
                    .font(Font.AppFont.textPrimary)
            }
            .foregroundColor(Color.ScanSemantic.galleryButtonIcon)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.ScanSemantic.galleryButtonBackground)
            .clipShape(Capsule())
        }
    }
}
