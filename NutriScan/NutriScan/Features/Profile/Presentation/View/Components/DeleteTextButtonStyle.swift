//
//  DeleteTextButtonStyle.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//

import SwiftUI

// MARK: - Custom Button Style
/// Handles both pointer hover (iPadOS/macOS) and touch press (iOS) states
struct DeleteTextButtonStyle: ButtonStyle {
    @State private var isHovering = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                configuration.isPressed || isHovering ? Color.Red.red500 : Color.Gray.gray400
            )
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovering = hovering
                }
            }
    }
}
