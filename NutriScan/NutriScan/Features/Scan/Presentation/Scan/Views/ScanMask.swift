import SwiftUI

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
                context.fill(
                    path,
                    with: .color(Color.ScanSemantic.scanningOverlay),
                    style: FillStyle(eoFill: true)
                )
            }
        }
        .allowsHitTesting(false)
    }
}
