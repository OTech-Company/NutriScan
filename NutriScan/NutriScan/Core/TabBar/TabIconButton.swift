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
                Image(systemName: tab.rawValue)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Self.iconColor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // التعديل هنا: الأيقونة بتصغر وتختفي في مكانها بنعومة
                    .scaleEffect(isSelected ? 0.0 : 1.0)
                    .opacity(isSelected ? 0 : 1)
            }
            .preference(
                key: TabBarPositionKey.self,
                value: [tab: proxy.frame(in: .named("TabBarCoordinateSpace")).midX]
            )
        }
        .frame(height: CustomAnimatedTabBar.barHeight)
    }
}
