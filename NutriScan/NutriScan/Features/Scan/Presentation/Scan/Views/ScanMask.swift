import SwiftUI

/// Dark scrim covering the full screen with a clear rounded "window"
/// cut out where the camera scan target sits.
struct ScanMask: View {
    var body: some View {
        GeometryReader { geo in
            let windowHeight: CGFloat = 260
            let windowWidth = geo.size.width - 80
            
            let windowY = ((geo.size.height - windowHeight) / 2) + 5

            Canvas { context, size in
                var path = Rectangle().path(in: CGRect(origin: .zero, size: size))
                let windowRect = CGRect(
                    x: (size.width - windowWidth) / 2,
                    y: windowY,
                    width: windowWidth,
                    height: windowHeight
                )
                path.addPath(RoundedRectangle(cornerRadius: 16).path(in: windowRect))
                context.fill(path, with: .color(.black.opacity(0.45)), style: FillStyle(eoFill: true))
            }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    ScanMask()
        .background(Color.gray)
}
