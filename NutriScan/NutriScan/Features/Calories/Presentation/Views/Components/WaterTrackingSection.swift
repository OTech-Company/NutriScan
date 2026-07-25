//
//  WaterTrackingSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 24/07/2026.
//

import SwiftUI

struct WaterTrackingSection: View {
    let currentGlasses: Int
    let goalGlasses: Int
    var onAddTap: () -> Void = {}
    
    @State private var showCups = false
    @State private var isTapped = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Header
            HStack {
                Text("Water")
                    .font(Font.AppFont.subtitle1)
                    .foregroundStyle(Color.CaloriesSemantic.waterTitle)
                Spacer()
                Text("\(currentGlasses)/\(goalGlasses)")
                    .font(Font.AppFont.textDefault)
                    .foregroundStyle(Color.CaloriesSemantic.waterCount)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentGlasses)
            }
            
            // Card
            HStack {
                // Cup icons with staggered entrance
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(0..<goalGlasses, id: \.self) { index in
                            Group {
                                if index < currentGlasses {
                                    Image(.filledCup)
                                        .foregroundStyle(Color.CaloriesSemantic.waterFilledCup)
                                } else {
                                    Image(.strokeCup)
                                        .foregroundStyle(Color.CaloriesSemantic.waterEmptyCup)
                                }
                            }
                            .scaleEffect(showCups ? 1 : 0)
                            .opacity(showCups ? 1 : 0)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.6)
                                    .delay(Double(index) * 0.06),
                                value: showCups
                            )
                            // Bounce when a cup gets filled
                            .scaleEffect(index == currentGlasses - 1 && isTapped ? 1.3 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: currentGlasses)
                        }
                    }
                }
                Spacer()
                AddCircleButton {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        isTapped = true
                    }
                    onAddTap()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            isTapped = false
                        }
                    }
                }
            }
            .padding(16)
            .frame(height: 74)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(Color.CaloriesSemantic.cardBackground)
            }
            .customLightShadow()
        }
        .onAppear {
            withAnimation {
                showCups = true
            }
        }
    }
}

#Preview("Light - 4/8") {
    WaterTrackingSection(currentGlasses: 4, goalGlasses: 8)
        .padding()
        .background(Color.CaloriesSemantic.background)
        .preferredColorScheme(.light)
}

#Preview("Dark - 6/8") {
    WaterTrackingSection(currentGlasses: 6, goalGlasses: 8)
        .padding()
        .background(Color.Teal.teal1600)
        .preferredColorScheme(.dark)
}
