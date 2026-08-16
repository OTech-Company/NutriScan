//
//  SplashScreen.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/01/1448 AH.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimated = false
    @State private var logoAppears = false
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
        
    var body: some View {
        ZStack {
            (isAnimated ? SplashSemanticColor.backgroundFinal : SplashSemanticColor.backgroundInitial)
                .ignoresSafeArea()
            
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    isAnimated
                                        ? SplashSemanticColor.largeGlowFinalLeading
                                        : SplashSemanticColor.largeGlowInitialLeading,
                                    isAnimated
                                        ? SplashSemanticColor.largeGlowFinalTrailing
                                        : SplashSemanticColor.largeGlowInitialTrailing
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: geo.size.width * 1.3, height: geo.size.width * 1.3)
                        .blur(radius: 40)
                        .scaleEffect(isAnimated ? 1.1 : 0.8)
                        .rotationEffect(.degrees(isAnimated ? 45 : 0))
                        .offset(
                            x: isAnimated ? geo.size.width * 0.2 : -geo.size.width * 0.5,
                            y: isAnimated ? geo.size.height * 0.8 : -geo.size.height * 0.2
                        )
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    isAnimated
                                        ? SplashSemanticColor.smallGlowFinalLeading
                                        : SplashSemanticColor.smallGlowInitialLeading,
                                    isAnimated
                                        ? SplashSemanticColor.smallGlowFinalTrailing
                                        : SplashSemanticColor.smallGlowInitialTrailing
                                ],
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                        )
                        .frame(width: geo.size.width * 0.9, height: geo.size.width * 0.9)
                        .blur(radius: 30)
                        .scaleEffect(isAnimated ? 1.0 : 0.7)
                        .rotationEffect(.degrees(isAnimated ? -30 : 15))
                        .offset(
                            x: isAnimated ? geo.size.width * 0.7 : -geo.size.width * 0.1,
                            y: isAnimated ? geo.size.height * 0.95 : -geo.size.height * 0.1
                        )
                }
            }
            .ignoresSafeArea()
            
            ZStack {
                Image("logo white")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240)
                    .foregroundStyle(SplashSemanticColor.logoInitial)
                    .opacity(logoAppears ? 0 : 1)
                    .scaleEffect(logoAppears ? 0.9 : 1.0)
                    .blur(radius: logoAppears ? 10 : 0)
                
                Image("logo teal")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240)
                    .foregroundStyle(SplashSemanticColor.logoFinal)
                    .opacity(logoAppears ? 1 : 0)
                    .scaleEffect(logoAppears ? 1.0 : 0.9)
                    .shadow(color: SplashSemanticColor.logoShadow, radius: 15, x: 0, y: 8)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 1.2, dampingFraction: 0.8, blendDuration: 0.5)) {
                    isAnimated = true
                }
                withAnimation(.easeInOut(duration: 1.2)) {
                    logoAppears = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                flowCoordinator.finishSplash()
            }
        }
    }
}

#Preview {
    SplashView()
}
