//
//  FloatingTabButton.swift
//  NutriScan
//
//  Created by albaraa alsayed on 01/02/1448 AH.
//

import SwiftUI


private struct CoinFlipModifier: ViewModifier {
    let angle: Double
    let scale: CGFloat
    let opacity: Double
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0))
            .scaleEffect(scale)
            .opacity(opacity)
    }
}

extension AnyTransition {
    static var coinFlipInsertion: AnyTransition {
        .modifier(
            active: CoinFlipModifier(angle: 180, scale: 0.5, opacity: 1),
            identity: CoinFlipModifier(angle: 0, scale: 1.0, opacity: 1)
        )
    }
}


struct FloatingTabButton: View {
    let selectedTab: AppTab
    
    @Environment(\.colorScheme) private var colorScheme
    
    private static let size: CGFloat = 60
    private static let cornerRadius: CGFloat = 12
    
    private var backgroundColor: Color {
        colorScheme == .light ? Color.Teal.teal1400 : Color.Teal.teal100
    }
    
    private var iconColor: Color {
        colorScheme == .light ? Color.Teal.teal100 : Color.Teal.teal1000
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Self.cornerRadius)
                .fill(backgroundColor)
                .frame(width: Self.size, height: Self.size)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 5)
            
            Image(systemName: AppTab.scan.rawValue)
                .font(.system(size: 32, weight: .semibold))
                .foregroundColor(iconColor)
        }
    }
}
