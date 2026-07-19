import SwiftUI

/// Draws the four independent corner brackets used as the scan viewfinder frame.
struct CornerBracketsShape: Shape {
    var cornerLength: CGFloat = 28
    var cornerRadius: CGFloat = 16

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // 1. Top-Left
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerLength))
        path.addArc(
            tangent1End: CGPoint(x: rect.minX, y: rect.minY),
            tangent2End: CGPoint(x: rect.minX + cornerLength, y: rect.minY),
            radius: cornerRadius
        )
        path.addLine(to: CGPoint(x: rect.minX + cornerLength, y: rect.minY))

        // 2. Top-Right
        path.move(to: CGPoint(x: rect.maxX - cornerLength, y: rect.minY))
        path.addArc(
            tangent1End: CGPoint(x: rect.maxX, y: rect.minY),
            tangent2End: CGPoint(x: rect.maxX, y: rect.minY + cornerLength),
            radius: cornerRadius
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerLength))

        // 3. Bottom-Right
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerLength))
        path.addArc(
            tangent1End: CGPoint(x: rect.maxX, y: rect.maxY),
            tangent2End: CGPoint(x: rect.maxX - cornerLength, y: rect.maxY),
            radius: cornerRadius
        )
        path.addLine(to: CGPoint(x: rect.maxX - cornerLength, y: rect.maxY))

        // 4. Bottom-Left
        path.move(to: CGPoint(x: rect.minX + cornerLength, y: rect.maxY))
        path.addArc(
            tangent1End: CGPoint(x: rect.minX, y: rect.maxY),
            tangent2End: CGPoint(x: rect.minX, y: rect.maxY - cornerLength),
            radius: cornerRadius
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerLength))

        return path
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        CornerBracketsShape()
            .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            .frame(width: 331, height: 260) // Matches your NutriScan Figma card width
            .padding(40)
    }
}
