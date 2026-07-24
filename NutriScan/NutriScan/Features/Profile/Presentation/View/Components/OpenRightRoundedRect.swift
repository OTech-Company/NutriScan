//
//  OpenRightRoundedRect.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import SwiftUI

struct OpenRightRoundedRect: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let minX = rect.minX
        let minY = rect.minY
        let maxY = rect.maxY
        let r = cornerRadius
        
        let farRight = rect.maxX + 3000
        
        path.move(to: CGPoint(x: farRight, y: minY))
        
        path.addArc(
            tangent1End: CGPoint(x: minX, y: minY),
            tangent2End: CGPoint(x: minX, y: maxY),
            radius: r
        )
        
        path.addArc(
            tangent1End: CGPoint(x: minX, y: maxY),
            tangent2End: CGPoint(x: farRight, y: maxY),
            radius: r
        )
        
        path.addLine(to: CGPoint(x: farRight, y: maxY))
        
        return path
    }
}
