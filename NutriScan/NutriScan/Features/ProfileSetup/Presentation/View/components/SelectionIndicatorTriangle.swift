//
//  SelectionIndicatorTriangle.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 17/07/2026.
//

import SwiftUI

struct SelectionIndicatorTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

struct SelectionIndicatorView: View {
    var body: some View {
        SelectionIndicatorTriangle()
            .fill(Color.ProfileSetupSemantic.selectionIndicator)
            .frame(width: 14, height: 8)
    }
}
