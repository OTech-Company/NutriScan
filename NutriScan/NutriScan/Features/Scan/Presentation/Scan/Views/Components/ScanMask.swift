import SwiftUI

/// Dark scrim covering the full screen with a clear rounded "window"
/// cut out where the camera scan target sits.
struct ScanMask: View {
    var windowHeight: CGFloat = 520
    var windowCornerRadius: CGFloat = 20
    var verticalOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let windowWidth = geo.size.width - 40
            let windowY = (geo.size.height - windowHeight) / 2 + verticalOffset

            Canvas { context, size in
                var path = Rectangle().path(in: CGRect(origin: .zero, size: size))
                let windowRect = CGRect(
                    x: (size.width - windowWidth) / 2,
                    y: windowY,
                    width: windowWidth,
                    height: windowHeight
                )
                path.addPath(RoundedRectangle(cornerRadius: windowCornerRadius).path(in: windowRect))
                context.fill(path, with: .color(.black.opacity(0.5)), style: FillStyle(eoFill: true))
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
