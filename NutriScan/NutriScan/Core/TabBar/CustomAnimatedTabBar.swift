//
//  CustomAnimatedTabBar.swift
//  NutriScan
//
//  Created by albaraa alsayed on 29/01/1448 AH.
//

import SwiftUI

struct CustomAnimatedTabBar: View {
    @Binding var selectedTab: AppTab

    @State private var animatedCurveTab: AppTab = .home
    @State private var tabPositions: [AppTab: CGFloat] = [:]

    /// Shared spring used for both the notch and floating button so they stay
    /// perfectly synchronised.
    private static let tabSpring: Animation = .spring(
        response: 0.6,
        dampingFraction: 0.65,
        blendDuration: 0.5
    )

    /// Height of the visible tab-bar region.
    static let barHeight: CGFloat = 60

    /// How far the floating button's center sits below the bar's top edge.
    /// Keeps the button visually centered inside the notch.
    private static let floatingButtonOffsetY: CGFloat = 2

    var body: some View {
        GeometryReader { geometry in
            let screenCenter = geometry.size.width / 2

            // The animated curve moves to the selected navigation tab.
            let currentCurveX = tabPositions[animatedCurveTab] ?? screenCenter
            
            // The center notch is permanently fixed in the center.
            let currentNotchX = screenCenter

            ZStack(alignment: .top) {

                // ── 1. Background shape ─────────────────────────────────────
                let isOverlappingCenter = abs(currentCurveX - currentNotchX) < 50
                TabBarBackground(
                    curveX: currentCurveX, 
                    notchX: currentNotchX, 
                    hideSmallNotch: selectedTab == .scan || isOverlappingCenter
                )

                // ── 2. Tab icons ────────────────────────────────────────────
                HStack(spacing: 0) {
                    ForEach(AppTab.allCases, id: \.self) { tab in
                        TabIconButton(
                            tab: tab,
                            isSelected: selectedTab == tab
                        ) {
                            withAnimation(Self.tabSpring) {
                                selectedTab = tab
                                animatedCurveTab = tab
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .coordinateSpace(name: "TabBarCoordinateSpace")

                // ── 3. Floating button ──────────────────────────────────────
                Button {
                    withAnimation(Self.tabSpring) {
                        selectedTab = .scan
                        animatedCurveTab = .scan
                    }
                } label: {
                    FloatingTabButton(selectedTab: selectedTab)
                }
                .buttonStyle(.plain)
                .position(x: currentNotchX, y: Self.floatingButtonOffsetY)
                .animation(Self.tabSpring, value: selectedTab)
            }
            .onPreferenceChange(TabBarPositionKey.self) { value in
                tabPositions.merge(value) { $1 }
            }
            .onAppear {
                animatedCurveTab = selectedTab
            }
        }
        .frame(height: Self.barHeight)
    }
}

// MARK: - TabBarBackground

/// Renders the teal tab-bar shape with the animated notch cut-out and shadow.
/// Extends into the bottom safe area so the colour bleeds edge-to-edge.
private struct TabBarBackground: View {
    let curveX: CGFloat
    let notchX: CGFloat
    let hideSmallNotch: Bool

    @Environment(\.colorScheme) private var colorScheme

    private var fillColor: Color {
        colorScheme == .light ? Color.Teal.teal800 : Color.Teal.teal1300
    }

    var body: some View {
        TabBarCurveShape(curveX: curveX, notchX: notchX, hideSmallNotch: hideSmallNotch)
            .fill(fillColor)
            .customTealShadow()
            .ignoresSafeArea(edges: .bottom)
    }
}

