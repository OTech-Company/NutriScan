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

    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    var body: some View {
        ZStack {
            Color.OnboardingSemantic.background
                .ignoresSafeArea()

            VStack {
                HStack {
                    if currentPage > 0 {
                        Button("BACK") {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                currentPage -= 1
                            }
                        }
                        .font(Font.AppFont.textPrimary)
                        .foregroundColor(Color.OnboardingSemantic.navButtonForeground)
                    }

                    Spacer()

                    if currentPage < OnboardingPage.allCases.count - 1 {
                        Button("SKIP") {
                            flowCoordinator.finishOnboarding()
                        }
                        .font(Font.AppFont.textPrimary)
                        .foregroundColor(Color.OnboardingSemantic.navButtonForeground)
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
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                if currentPage < OnboardingPage.allCases.count - 1 {
                                    currentPage += 1
                                } else {
                                    flowCoordinator.finishOnboarding()
                                }
                            }
                        }
                    )

                    HStack(spacing: 8) {
                        ForEach(0 ..< OnboardingPage.allCases.count, id: \.self) { index in
                            let isSelected = (index == currentPage)
                            let selectedColor = Color.OnboardingSemantic.dotSelected
                            let unselectedColor = Color.OnboardingSemantic.dotUnselected

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
        let currentImage = page.imageName

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
                .foregroundColor(Color.OnboardingSemantic.pageTitle)
                .multilineTextAlignment(.center)

            Text(page.description)
                .font(Font.AppFont.textSecondary)
                .foregroundColor(Color.OnboardingSemantic.pageDescription)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .lineSpacing(4)
                .opacity(isActive ? 1 : 0)
                .offset(y: isActive ? 0 : 20)
                .animation(.spring(dampingFraction: 0.8).delay(0.2), value: isActive)
        }
    }
}

#Preview {
    OnboardingScreen()
        .environmentObject(AppFlowCoordinator())
}
