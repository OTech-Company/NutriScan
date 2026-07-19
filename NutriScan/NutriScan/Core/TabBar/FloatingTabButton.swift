//
//  FloatingTabButton.swift
//  NutriScan
//
//  Created by albaraa alsayed on 01/02/1448 AH.
//

import SwiftUI

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
        let isSelected = selectedTab == .scan
        
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: Self.cornerRadius)
                    .fill(backgroundColor)
                    .frame(width: Self.size, height: Self.size)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 5)
                    .overlay {
                        // Glass Shine Animation
                        if !isSelected {
                            GeometryReader { proxy in
                                let w = proxy.size.width
                                LinearGradient(
                                    stops: [
                                        .init(color: .clear, location: 0.35),
                                        .init(color: .white.opacity(0.2), location: 0.5),
                                        .init(color: .clear, location: 0.65)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .frame(width: w * 2)
                                .keyframeAnimator(initialValue: -w * 2, repeating: true) { content, value in
                                    content.offset(x: value)
                                } keyframes: { _ in
                                    KeyframeTrack {
                                        // First Shine (syncs with Right rotation with 0.05s delay)
                                        LinearKeyframe(-w * 2, duration: 0.05)
                                        LinearKeyframe(w * 1.5, duration: 2.0)
                                        LinearKeyframe(-w * 2, duration: 0.0)
                                        LinearKeyframe(-w * 2, duration: 0.45) // 0.05 + 2.0 + 0.45 = 2.5
                                        
                                        // Second Shine (syncs with Left rotation with 0.05s delay)
                                        LinearKeyframe(-w * 2, duration: 0.05)
                                        LinearKeyframe(w * 1.5, duration: 2.0)
                                        LinearKeyframe(-w * 2, duration: 0.0)
                                        LinearKeyframe(-w * 2, duration: 0.45) // 0.05 + 2.0 + 0.45 = 2.5
                                    }
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: Self.cornerRadius))
                            .blendMode(.screen)
                            .allowsHitTesting(false)
                        }
                    }
            }
            .keyframeAnimator(initialValue: 0.0, repeating: !isSelected) { content, value in
                content
                    .scaleEffect(1.0 + (0.04 * abs(value)))
                    .rotationEffect(.degrees(1.5 * value))
            } keyframes: { _ in
                KeyframeTrack {
                    // Rotate Right (with 0.05s mini delay)
                    CubicKeyframe(0.0, duration: 0.05)
                    CubicKeyframe(1.0, duration: 1.0)
                    CubicKeyframe(0.0, duration: 1.0)
                    CubicKeyframe(0.0, duration: 0.45)
                    
                    // Rotate Left (with 0.05s mini delay)
                    CubicKeyframe(0.0, duration: 0.05)
                    CubicKeyframe(-1.0, duration: 1.0)
                    CubicKeyframe(0.0, duration: 1.0)
                    CubicKeyframe(0.0, duration: 0.45)
                }
            }
            
            Group {
                if isSelected {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 28, weight: .semibold))
                } else {
                    Image(AppTab.scan.rawValue)
                        .keyframeAnimator(initialValue: 0.0, repeating: true) { content, value in
                            content
                                .scaleEffect(1.0 + (0.1 * abs(value)))
                                .rotationEffect(.degrees(4.0 * value))
                        } keyframes: { _ in
                            KeyframeTrack {
                                // Rotate Right
                                CubicKeyframe(1.0, duration: 1.0)
                                CubicKeyframe(0.0, duration: 1.0)
                                CubicKeyframe(0.0, duration: 0.5) // delay
                                
                                // Rotate Left
                                CubicKeyframe(-1.0, duration: 1.0)
                                CubicKeyframe(0.0, duration: 1.0)
                                CubicKeyframe(0.0, duration: 0.5) // delay
                            }
                        }
                }
            }
            .foregroundColor(iconColor)
        }
    }
}
