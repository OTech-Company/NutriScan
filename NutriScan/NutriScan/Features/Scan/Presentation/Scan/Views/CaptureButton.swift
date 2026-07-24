import SwiftUI

struct CaptureButton: View {
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .stroke(Color.ScanSemantic.captureOuterRing, lineWidth: 4)
                    .frame(width: 80, height: 80)

                Circle()
                    .fill(Color.ScanSemantic.captureInnerCircle)
                    .frame(width: 64, height: 64)
                    .scaleEffect(isPressed ? 0.9 : 1.0)

                Image(systemName: "camera.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color.ScanSemantic.captureOuterRing)
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}
