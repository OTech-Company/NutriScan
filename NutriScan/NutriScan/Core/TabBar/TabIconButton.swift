//
//  TabBarIcon.swift
//  NutriScan
//
//  Created by albaraa alsayed on 01/02/1448 AH.
//

import SwiftUI

struct TabIconButton: View {
    let tab: AppTab
    let isSelected: Bool
    let action: () -> Void
    
    private static let iconColor: Color = Color.Teal.teal100
    
    var body: some View {
        GeometryReader { proxy in
            Button(action: {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                action()
            }) {
                ZStack {
                    if tab != .scan {
                        // Unselected (stroke)
                        Image(tab.rawValue)
                            // .font(.system(size: 24, weight: .semibold)) // removed, not applicable for Image asset
                            .foregroundColor(Self.iconColor)
                            .opacity(isSelected ? 0 : 1)
                            .rotation3DEffect(
                                .degrees(isSelected ? 89.9 : 0),
                                axis: (x: 1.0, y: 0.0, z: 0.0)
                            )
                        
                        // Selected (fill)
                        Image(tab.filledIcon)
                            // .font(.system(size: 24, weight: .semibold)) // removed, not applicable for Image asset
                            .foregroundColor(Self.iconColor)
                            .opacity(isSelected ? 1 : 0)
                            .rotation3DEffect(
                                .degrees(isSelected ? 0 : -89.9),
                                axis: (x: 1.0, y: 0.0, z: 0.0)
                            )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .preference(
                key: TabBarPositionKey.self,
                value: [tab: proxy.frame(in: .named("TabBarCoordinateSpace")).midX]
            )
        }
        .frame(height: CustomAnimatedTabBar.barHeight)
    }
}
