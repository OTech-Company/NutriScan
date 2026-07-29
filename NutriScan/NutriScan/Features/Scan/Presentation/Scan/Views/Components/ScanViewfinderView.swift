import SwiftUI

/// The scan viewfinder with corner brackets and animated scanning wave.
struct ScanViewfinderView: View {
    var cornerLength: CGFloat = 32
    var cornerRadius: CGFloat = 20
    var isScanning: Bool = true

    var body: some View {
        ZStack {
            // Viewfinder rectangle border
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)

            // Corner brackets
            CornerBracketsShape(cornerLength: cornerLength, cornerRadius: cornerRadius)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))

            // Scanning wave animation (hidden when not scanning)
            if isScanning {
                ScanningWaveView()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
        }
    }
}
