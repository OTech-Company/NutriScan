//
//  CustomAnimatedTabBar.swift
//  NutriScan
//
//  Created by albaraa alsayed on 29/01/1448 AH.
//

import SwiftUI

// MARK: - CustomAnimatedTabBar

struct CustomAnimatedTabBar: View {
    @Binding var selectedTab: AppTab

    @State private var tabPositions: [AppTab: CGFloat] = [:]

    /// Shared spring used for both the notch and floating button so they stay
    /// perfectly synchronised.
    private static let tabSpring: Animation = .spring(
        response: 0.6,
        dampingFraction: 0.65,
        blendDuration: 0.5
    )

    /// Height of the visible tab-bar region (matches the SVG: y 30→110 = 80 pt).
    static let barHeight: CGFloat = 80

    /// How far the floating button's center sits below the bar's top edge.
    /// Keeps the button visually centered inside the notch.
    private static let floatingButtonOffsetY: CGFloat = 2

    var body: some View {
        // Fall back to screen center before GeometryReader preferences arrive.
        let currentX = tabPositions[selectedTab]
            ?? UIScreen.main.bounds.width / 2

        ZStack(alignment: .top) {

            // ── 1. Background shape ─────────────────────────────────────
            TabBarBackground(xAxis: currentX)

            // ── 2. Tab icons ────────────────────────────────────────────
            HStack(spacing: 0) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    TabIconButton(
                        tab: tab,
                        isSelected: selectedTab == tab
                    ) {
                        withAnimation(Self.tabSpring) {
                            selectedTab = tab
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .coordinateSpace(name: "TabBarCoordinateSpace")

            // ── 3. Floating button ──────────────────────────────────────
            FloatingTabButton(selectedTab: selectedTab)
                .position(x: currentX, y: Self.floatingButtonOffsetY)
                .animation(Self.tabSpring, value: selectedTab)
        }
        .frame(height: Self.barHeight)
        .onPreferenceChange(TabBarPositionKey.self) { value in
            tabPositions.merge(value) { $1 }
        }
    }
}

// MARK: - TabBarBackground

/// Renders the teal tab-bar shape with the animated notch cut-out and shadow.
/// Extends into the bottom safe area so the colour bleeds edge-to-edge.
private struct TabBarBackground: View {
    let xAxis: CGFloat

    @Environment(\.colorScheme) private var colorScheme

    private var fillColor: Color {
        colorScheme == .light ? Color.Teal.teal800 : Color.Teal.teal1300
    }

    var body: some View {
        AnimatedNotchShape(xAxis: xAxis)
            .fill(fillColor)
            .customTealShadow()
            .ignoresSafeArea(edges: .bottom)
    }
}

