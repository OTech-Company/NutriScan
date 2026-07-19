//
//  BadgeLabel.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

// MARK: - Badge Label
struct BadgeLabel: View {
    let text: String
    let systemIcon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: systemIcon)
                .foregroundColor(color)
            Text(text)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.85))
        .cornerRadius(20)
    }
}

// MARK: - Rounded Corner Shape Helper
struct RoundedCornerShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
