//
//  TopSafeAreaScrollView.swift
//  NutriScan
//

import SwiftUI

struct TopSafeAreaScrollPhase: Equatable {
    let offset: CGFloat
    let progress: CGFloat

    var isCollapsed: Bool {
        progress >= 0.8
    }

    static let initial = TopSafeAreaScrollPhase(offset: 0, progress: 0)
}

struct TopSafeAreaScrollView<TopBar: View, ExpandedHeader: View, Content: View>: View {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    private let background: Color
    private let showsIndicators: Bool
    private let refreshAction: (() async -> Void)?
    private let topBar: (TopSafeAreaScrollPhase) -> TopBar
    private let expandedHeader: (TopSafeAreaScrollPhase) -> ExpandedHeader
    private let content: () -> Content

    @State private var offset: CGFloat = 0
    @State private var topBarHeight: CGFloat = 1
    @State private var expandedHeaderHeight: CGFloat = 0

    private let coordinateSpaceName = "top-safe-area-scroll"

    init(
        background: Color,
        showsIndicators: Bool = false,
        refreshAction: (() async -> Void)? = nil,
        @ViewBuilder topBar: @escaping (TopSafeAreaScrollPhase) -> TopBar,
        @ViewBuilder expandedHeader: @escaping (TopSafeAreaScrollPhase) -> ExpandedHeader,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.background = background
        self.showsIndicators = showsIndicators
        self.refreshAction = refreshAction
        self.topBar = topBar
        self.expandedHeader = expandedHeader
        self.content = content
    }

    var body: some View {
        ZStack {
            background.ignoresSafeArea()
            platformScrollView
        }
    }

    private var phase: TopSafeAreaScrollPhase {
        let collapseDistance = max(expandedHeaderHeight, topBarHeight, 1)
        let progress = min(max(offset / collapseDistance, 0), 1)
        return TopSafeAreaScrollPhase(offset: offset, progress: progress)
    }

    @ViewBuilder
    private var platformScrollView: some View {
#if compiler(>=6.2)
        if #available(iOS 26.0, *) {
            scrollView
                .safeAreaBar(edge: .top, spacing: 0) {
                    measuredTopBar
                }
                .scrollEdgeEffectStyle(.soft, for: .top)
        } else {
            legacyScrollView
        }
#else
        legacyScrollView
#endif
    }

    private var legacyScrollView: some View {
        scrollView
            .safeAreaInset(edge: .top, spacing: 0) {
                measuredTopBar
                    .background {
                        legacyBarBackground
                    }
            }
    }

    @ViewBuilder
    private var scrollView: some View {
        if let refreshAction {
            scrollSurface
                .refreshable {
                    await refreshAction()
                }
        } else {
            scrollSurface
        }
    }

    private var scrollSurface: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            VStack(spacing: 0) {
                scrollOffsetMarker

                expandedHeader(phase)
                    .onGeometryChange(for: CGFloat.self) { geometry in
                        geometry.size.height
                    } action: { newHeight in
                        guard newHeight > 0, newHeight != expandedHeaderHeight else { return }
                        expandedHeaderHeight = newHeight
                    }

                content()
            }
        }
        .coordinateSpace(name: coordinateSpaceName)
    }

    private var scrollOffsetMarker: some View {
        Color.clear
            .frame(height: 0)
            .onGeometryChange(for: CGFloat.self) { geometry in
                geometry.frame(in: .named(coordinateSpaceName)).minY
            } action: { minY in
                let newOffset = max(-minY, 0)
                guard abs(newOffset - offset) >= 0.5 else { return }
                offset = newOffset
            }
    }

    private var measuredTopBar: some View {
        topBar(phase)
            .frame(maxWidth: .infinity)
            .onGeometryChange(for: CGFloat.self) { geometry in
                geometry.size.height
            } action: { newHeight in
                guard newHeight > 0, newHeight != topBarHeight else { return }
                topBarHeight = newHeight
            }
    }

    @ViewBuilder
    private var legacyBarBackground: some View {
        let visibility = min(max(phase.progress * 2, 0), 1)

        if reduceTransparency {
            background
                .opacity(visibility)
        } else {
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(visibility)
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [.clear, background.opacity(0.18)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 10)
                    .opacity(visibility)
                }
        }
    }
}

extension TopSafeAreaScrollView where ExpandedHeader == EmptyView {
    init(
        background: Color,
        showsIndicators: Bool = false,
        refreshAction: (() async -> Void)? = nil,
        @ViewBuilder topBar: @escaping (TopSafeAreaScrollPhase) -> TopBar,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            background: background,
            showsIndicators: showsIndicators,
            refreshAction: refreshAction,
            topBar: topBar,
            expandedHeader: { _ in EmptyView() },
            content: content
        )
    }
}
