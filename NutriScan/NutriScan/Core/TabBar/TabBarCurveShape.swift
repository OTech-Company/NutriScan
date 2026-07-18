//
//  TabBarCurveShape.swift
//  NutriScan
//
//  Created by albaraa alsayed on 01/02/1448 AH.
//

import SwiftUI

/// A shape that reproduces the exact SVG tab-bar design.
/// It draws a single continuous path containing the fixed center notch 
/// and the moving selection indicator notch.
struct TabBarCurveShape: Shape {
    /// Horizontal center of the small animated selection indicator.
    var curveX: CGFloat
    
    /// Horizontal center of the large fixed scan button notch.
    var notchX: CGFloat
    
    /// If true, the small selection indicator is hidden.
    var hideSmallNotch: Bool

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(curveX, notchX) }
        set {
            curveX = newValue.first
            notchX = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        let W = rect.width
        let H = rect.height + 200 // bleed into safe area
        let cr: CGFloat = 32.0

        var path = Path()

        // Start bottom-left
        path.move(to: CGPoint(x: 0, y: H))
        
        // Left edge up to corner
        path.addLine(to: CGPoint(x: 0, y: cr))
        
        // Left corner (SVG: C0,44.33, 14.33,30, 32,30 translated to relative y=0)
        path.addCurve(
            to: CGPoint(x: cr, y: 0),
            control1: CGPoint(x: 0, y: 14.33),
            control2: CGPoint(x: 14.33, y: 0)
        )

        // Draw notches left-to-right based on their horizontal order
        if hideSmallNotch {
            // Just draw the big notch
            path.addLine(to: CGPoint(x: notchX - 60.115, y: 0))
            addBigNotch(to: &path, center: notchX)
        } else if curveX < notchX {
            // Small notch first
            path.addLine(to: CGPoint(x: curveX - 15.25, y: 0))
            addSmallNotch(to: &path, center: curveX)
            
            // Only connect if the notches are far enough apart
            if curveX + 15.25 < notchX - 60.115 {
                path.addLine(to: CGPoint(x: notchX - 60.115, y: 0))
            }
            addBigNotch(to: &path, center: notchX)
        } else {
            // Big notch first
            path.addLine(to: CGPoint(x: notchX - 60.115, y: 0))
            addBigNotch(to: &path, center: notchX)
            
            // Only connect if the notches are far enough apart
            if notchX + 60.115 < curveX - 15.25 {
                path.addLine(to: CGPoint(x: curveX - 15.25, y: 0))
            }
            addSmallNotch(to: &path, center: curveX)
        }

        // Line to right corner
        path.addLine(to: CGPoint(x: W - cr, y: 0))
        
        // Right corner
        path.addCurve(
            to: CGPoint(x: W, y: cr),
            control1: CGPoint(x: W - 14.33, y: 0),
            control2: CGPoint(x: W, y: 14.33)
        )
        
        // Right edge down
        path.addLine(to: CGPoint(x: W, y: H))
        path.closeSubpath()

        return path
    }

    private func addBigNotch(to path: inout Path, center: CGFloat) {
        // Curve 1
        path.addCurve(
            to: CGPoint(x: center - 39.995, y: 20.12),
            control1: CGPoint(x: center - 49.005, y: 0),
            control2: CGPoint(x: center - 39.995, y: 9.01)
        )
        
        // Curve 2
        path.addCurve(
            to: CGPoint(x: center - 19.875, y: 40.25),
            control1: CGPoint(x: center - 39.995, y: 31.23),
            control2: CGPoint(x: center - 30.985, y: 40.25)
        )
        
        // Flat bottom
        path.addLine(to: CGPoint(x: center + 19.875, y: 40.25))
        
        // Curve 3
        path.addCurve(
            to: CGPoint(x: center + 39.995, y: 20.13),
            control1: CGPoint(x: center + 30.985, y: 40.25),
            control2: CGPoint(x: center + 39.995, y: 31.24)
        )
        
        // Curve 4
        path.addCurve(
            to: CGPoint(x: center + 60.115, y: 0),
            control1: CGPoint(x: center + 39.995, y: 9.02),
            control2: CGPoint(x: center + 49.005, y: 0)
        )
    }

    private func addSmallNotch(to path: inout Path, center: CGFloat) {
        func nx(_ off: CGFloat) -> CGFloat { center + off }
        
        // Start is at nx(-15.25), y=0
        
        // Curve 1 (c 3.33,0, 6.24,1.86, 7.73,4.6)
        path.addCurve(
            to: CGPoint(x: nx(-7.52), y: 4.60),
            control1: CGPoint(x: nx(-11.92), y: 0.00),
            control2: CGPoint(x: nx(-9.01), y: 1.86)
        )
        
        // Curve 2 (c 1.55,2.54, 4.34,4.23, 7.52,4.23)
        path.addCurve(
            to: CGPoint(x: nx(0.00), y: 8.83),
            control1: CGPoint(x: nx(-5.97), y: 7.14),
            control2: CGPoint(x: nx(-3.18), y: 8.83)
        )
        
        // Curve 3 (s 5.97-1.69, 7.52-4.23)
        path.addCurve(
            to: CGPoint(x: nx(7.52), y: 4.60),
            control1: CGPoint(x: nx(3.18), y: 8.83),
            control2: CGPoint(x: nx(5.97), y: 7.14)
        )
        
        // Curve 4 (c .07-.13, .14-.25, .21-.37)
        path.addCurve(
            to: CGPoint(x: nx(7.73), y: 4.23),
            control1: CGPoint(x: nx(7.59), y: 4.47),
            control2: CGPoint(x: nx(7.66), y: 4.35)
        )
        
        // Curve 5 (c 1.54-2.54, 4.33-4.23, 7.51-4.23)
        path.addCurve(
            to: CGPoint(x: nx(15.24), y: 0.00),
            control1: CGPoint(x: nx(9.27), y: 1.69),
            control2: CGPoint(x: nx(12.06), y: 0.00)
        )
    }
}
