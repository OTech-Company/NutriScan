//
//  AddCircleButton.swift
//  NutriScan
//
//  Created by albaraa alsayed on 24/07/2026.
//

import SwiftUI

struct AddCircleButton: View {
    let accessibilityLabel: String
    var accessibilityHint: String? = nil
    var size: CGFloat = 36
    var action: () -> Void = {}
    
    @State private var isTapped = false
    
    var body: some View {
        Button {
            // Bounce animation on tap
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                isTapped = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isTapped = false
                }
            }
            action()
        } label: {
            Image(.plus)
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.4, height: size * 0.4)
                .foregroundColor(Color.CaloriesSemantic.addButtonIcon)
                .rotationEffect(.degrees(isTapped ? 90 : 0))
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .foregroundStyle(
                            size > 50
                                ? Color.CaloriesSemantic.addButtonLargeBackground
                                : Color.CaloriesSemantic.addButtonBackground
                        )
                )
                .scaleEffect(isTapped ? 1.2 : 1.0)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint ?? "")
    }
}

#Preview("Small") {
    AddCircleButton(accessibilityLabel: "Add", size: 36) {}
        .padding()
        .background(Color.CaloriesSemantic.background)
}

#Preview("Large") {
    AddCircleButton(accessibilityLabel: "Add", size: 60) {}
        .padding()
        .background(Color.CaloriesSemantic.background)
}
