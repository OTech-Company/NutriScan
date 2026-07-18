//
//  CustomPuffedButton.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/01/1448 AH.
//

import SwiftUI

struct CustomPuffedShape: Shape {
    var puffHeight: CGFloat = 5
    var cornerRadius: CGFloat = 14
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let insetY = puffHeight
        
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + insetY))
        
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + insetY),
            control: CGPoint(x: rect.midX, y: rect.minY)
        )
        
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + insetY + cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: -90),
            endAngle: Angle(degrees: 0),
            clockwise: false
        )
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - insetY - cornerRadius))
        
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - insetY - cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 90),
            clockwise: false
        )
        
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - insetY),
            control: CGPoint(x: rect.midX, y: rect.maxY)
        )
        
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - insetY - cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 180),
            clockwise: false
        )
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + insetY + cornerRadius))
        
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + insetY + cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 180),
            endAngle: Angle(degrees: 270),
            clockwise: false
        )
        
        path.closeSubpath()
        
        return path
    }
}

struct CustomPuffedButton: View {
    var title: String
    var action: () -> Void
    var isLoading: Bool = false

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 62)
            .background(Color.Teal.teal1000)
            .clipShape(CustomPuffedShape(puffHeight: 5, cornerRadius: 14))
            .customTealShadow()
        }
        .disabled(isLoading)
    }
}

#Preview {
    CustomPuffedButton(title: "Test Button", action: {})
}
