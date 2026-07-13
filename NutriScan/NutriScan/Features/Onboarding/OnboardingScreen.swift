//
//  OnboardingScreen.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/01/1448 AH.
//

import SwiftUI

struct OnboardingScreen: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.Teal.teal1600 : .white)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    if currentPage > 0 {
                        Button("BACK") {
                            // Applied spring animation here
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                currentPage -= 1
                            }
                        }
                        .font(Font.AppFont.textPrimary)
                        .foregroundColor(colorScheme == .dark ? Color.Teal.teal400 : .gray)
                    }
                    
                    Spacer()
                    
                    if currentPage < OnboardingPage.allCases.count - 1 {
                        Button("SKIP") {
                            print("Home Screen will appear")
                        }
                        .font(Font.AppFont.textPrimary)
                        .foregroundColor(colorScheme == .dark ? Color.Teal.teal400 : .gray)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                TabView(selection: $currentPage) {
                    ForEach(OnboardingPage.allCases, id: \.rawValue) { page in
                        getPageView(for: page)
                            .tag(page.rawValue)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                .onAppear { isAnimating = true }
                
                Spacer()
                
                VStack(spacing: 30) {
                    CustomPuffedButton(
                        title: OnboardingPage.allCases[currentPage].buttonTitle,
                        action: {
                            // Applied spring animation here to remove the default opacity transition
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                if currentPage < OnboardingPage.allCases.count - 1 {
                                    currentPage += 1
                                } else {
                                    print("Home Screen will appear")
                                }
                            }
                        }
                    )
                    
                    HStack(spacing: 8) {
                        ForEach(0 ..< OnboardingPage.allCases.count, id: \.self) { index in
                            let isSelected = (index == currentPage)
                            let selectedColor = colorScheme == .dark ? Color.Teal.teal700 : Color.gray
                            let unselectedColor = colorScheme == .dark ? Color.Teal.teal1300 : Color.gray.opacity(0.3)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(isSelected ? selectedColor : unselectedColor)
                                .frame(width: isSelected ? 30 : 8, height: 8)
                                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .safeAreaPadding()
        }
    }
    
    private func getPageView(for page: OnboardingPage) -> some View {
        let isActive = (currentPage == page.rawValue)
        let currentImage = colorScheme == .dark ? page.darkImage : page.lightImage
        
        return VStack(spacing: 24) {
            Image(currentImage)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .scaleEffect(isActive ? 1.0 : 0.6)
                .opacity(isActive ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.5), value: isActive)
            
            Text(page.title)
                .font(Font.AppFont.title2)
                .foregroundColor(colorScheme == .dark ? Color.Teal.teal100 : .primary)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(Font.AppFont.textSecondary)
                .foregroundColor(colorScheme == .dark ? Color.Teal.teal400 : .secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .lineSpacing(4)
                .opacity(isActive ? 1 : 0)
                .offset(y: isActive ? 0: 20)
                .animation(.spring(dampingFraction: 0.8).delay(0.2), value: isActive)
        }
    }
}

#Preview {
    OnboardingScreen()
}
