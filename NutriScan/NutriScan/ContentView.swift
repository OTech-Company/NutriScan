//
//  ContentView.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 13/07/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSplash = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen(onComplete: {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showSplash = false
                    }
                })
                .transition(.opacity) 
            } else if !hasSeenOnboarding {
                OnboardingScreen()
            } else {
                // Your Main App Screen
                VStack(spacing: 16) {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Welcome to NutriScan Home!")
                        .font(Font.AppFont.title3)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
