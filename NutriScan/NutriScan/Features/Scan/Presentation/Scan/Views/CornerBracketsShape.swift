import SwiftUI

/// Draws four independent corner brackets used as the scan viewfinder frame.
struct CornerBracketsShape: Shape {
    var cornerLength: CGFloat = 28
    var cornerRadius: CGFloat = 16

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let tl = CGPoint(x: rect.minX, y: rect.minY)
        let tr = CGPoint(x: rect.maxX, y: rect.minY)
        let br = CGPoint(x: rect.maxX, y: rect.maxY)
        let bl = CGPoint(x: rect.minX, y: rect.maxY)

        // Top-Left
        path.move(to: CGPoint(x: tl.x, y: tl.y + cornerLength))
        path.addArc(tangent1End: tl, tangent2End: CGPoint(x: tl.x + cornerLength, y: tl.y), radius: cornerRadius)
        path.addLine(to: CGPoint(x: tl.x + cornerLength, y: tl.y))

        // Top-Right
        path.move(to: CGPoint(x: tr.x - cornerLength, y: tr.y))
        path.addArc(tangent1End: tr, tangent2End: CGPoint(x: tr.x, y: tr.y + cornerLength), radius: cornerRadius)
        path.addLine(to: CGPoint(x: tr.x, y: tr.y + cornerLength))

        // Bottom-Right
        path.move(to: CGPoint(x: br.x, y: br.y - cornerLength))
        path.addArc(tangent1End: br, tangent2End: CGPoint(x: br.x - cornerLength, y: br.y), radius: cornerRadius)
        path.addLine(to: CGPoint(x: br.x - cornerLength, y: br.y))

        // Bottom-Left
        path.move(to: CGPoint(x: bl.x + cornerLength, y: bl.y))
        path.addArc(tangent1End: bl, tangent2End: CGPoint(x: bl.x, y: bl.y - cornerLength), radius: cornerRadius)
        path.addLine(to: CGPoint(x: bl.x, y: bl.y - cornerLength))

        return path
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CornerBracketsShape()
            .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            .frame(width: 280, height: 260)
    }
}
