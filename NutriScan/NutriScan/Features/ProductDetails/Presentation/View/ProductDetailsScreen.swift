//
//  ProductDetailsScreen.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import SwiftUI

struct ProductDetailsScreen: View {
    private enum AlertDestination: String, Identifiable {
        case loadError
        var id: String { rawValue }
    }

    @EnvironmentObject private var router: AppRouter
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: ProductDetailsViewModel
    @State private var alert: AlertDestination?
    @State private var isHeaderPresented = false
    @State private var isContentPresented = false
    @State private var isHoldingShimmer: Bool
    @State private var canPresentLoadError = false
    @State private var hasStartedInitialPresentation = false
    @State private var loadGeneration = 0

    @MainActor
    init(scanId: String) {
        let viewModel = ProductDetailsFactory.makeProductDetailsViewModel(scanId: scanId)
        _viewModel = State(wrappedValue: viewModel)
        _isHoldingShimmer = State(initialValue: viewModel.isLoading)
    }

    /// Init with pre-loaded ScanDetail — no API call needed.
    @MainActor
    init(scanDetail: ScanDetail) {
        let viewModel = ProductDetailsFactory.makeProductDetailsViewModel(scanDetail: scanDetail)
        _viewModel = State(wrappedValue: viewModel)
        _isHoldingShimmer = State(initialValue: viewModel.isLoading)
    }

    var body: some View {
        VStack(spacing: 0) {
            header
                .opacity(isHeaderPresented ? 1 : 0)
                .offset(y: reduceMotion || isHeaderPresented ? 0 : -12)

            content
                .opacity(isContentPresented ? 1 : 0)
                .scaleEffect(reduceMotion || isContentPresented ? 1 : 0.97, anchor: .top)
                .offset(y: reduceMotion || isContentPresented ? 0 : 32)
                .animation(contentSwapAnimation, value: viewModel.isLoading)
                .animation(contentSwapAnimation, value: isHoldingShimmer)
        }
        .background(Color.Teal.teal1000)
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .task(id: loadGeneration) {
            if hasStartedInitialPresentation {
                await performRetryLoad()
            } else {
                hasStartedInitialPresentation = true
                await performInitialPresentation()
            }
        }
        .onChange(of: viewModel.failureMessage) { _, message in
            if message != nil && canPresentLoadError {
                alert = .loadError
            }
        }
        .onChange(of: canPresentLoadError) { _, canPresent in
            if canPresent && viewModel.failureMessage != nil {
                alert = .loadError
            }
        }
        .customAlert(item: $alert, config: { _ in
            CustomAlertConfig(
                    type: .error,
                    title: "Error",
                    message: viewModel.failureMessage ?? "An unknown error occurred",
                    primaryButton: CustomAlertButton("Retry")
                )
        }, primaryAction: { _ in
            viewModel.failureMessage = nil
            loadGeneration += 1
        })
    }

    private var header: some View {
        HStack {
            HStack(spacing: 16) {
                BackButton(action: { router.pop() }, style: .onTeal)
                Text("Product Details")
                    .font(Font.AppFont.subtitle1)
                    .foregroundStyle(Color.white)
            }
            Spacer()

            if let isFavorite = viewModel.uiState?.isFavorite {
                Image(isFavorite ? .bookmarkFill : .bookmarkStroke)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color.Teal.teal700)
                    }
                    .onTapGesture {
                        viewModel.toggleFavorite()
                    }
            } else {
                Image(.bookmarkStroke)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color.Teal.teal700)
                    }
            }
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading || isHoldingShimmer {
            ProductDetailsShimmerView()
                .transition(productContentTransition)
        } else if let uiState = viewModel.uiState {
            ProductSheetView(state: uiState)
                .transition(productContentTransition)
        } else {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var productContentTransition: AnyTransition {
        reduceMotion
            ? .opacity
            : .modifier(
                active: ProductDetailsContentTransitionModifier(
                    opacity: 0,
                    scale: 0.985,
                    verticalOffset: 10
                ),
                identity: ProductDetailsContentTransitionModifier(
                    opacity: 1,
                    scale: 1,
                    verticalOffset: 0
                )
            )
    }

    private var headerEntranceAnimation: Animation {
        reduceMotion ? .easeOut(duration: 0.15) : .easeOut(duration: 0.22)
    }

    private var contentEntranceAnimation: Animation {
        reduceMotion
            ? .easeOut(duration: 0.15)
            : .spring(response: 0.48, dampingFraction: 0.86, blendDuration: 0.08)
    }

    private var contentSwapAnimation: Animation {
        reduceMotion
            ? .easeOut(duration: 0.15)
            : .spring(response: 0.34, dampingFraction: 0.9, blendDuration: 0.05)
    }

    private func performInitialPresentation() async {
        async let load: Void = viewModel.loadProductDetails()

        guard await presentScreenContent() else { return }

        if isHoldingShimmer {
            guard await wait(for: .milliseconds(500)) else { return }
        }

        await load
        guard !Task.isCancelled else { return }
        finishLoadingPresentation()
    }

    private func performRetryLoad() async {
        canPresentLoadError = false
        withAnimation(contentSwapAnimation) {
            isHoldingShimmer = true
        }

        async let load: Void = viewModel.loadProductDetails()
        guard await wait(for: .milliseconds(500)) else { return }

        await load
        guard !Task.isCancelled else { return }
        finishLoadingPresentation()
    }

    private func presentScreenContent() async -> Bool {
        if reduceMotion {
            withAnimation(headerEntranceAnimation) {
                isHeaderPresented = true
                isContentPresented = true
            }
            return true
        }

        guard await wait(for: .milliseconds(140)) else { return false }
        withAnimation(headerEntranceAnimation) {
            isHeaderPresented = true
        }

        guard await wait(for: .milliseconds(45)) else { return false }
        withAnimation(contentEntranceAnimation) {
            isContentPresented = true
        }
        return true
    }

    private func finishLoadingPresentation() {
        withAnimation(contentSwapAnimation) {
            isHoldingShimmer = false
        }
        canPresentLoadError = true
    }

    private func wait(for duration: Duration) async -> Bool {
        do {
            try await Task.sleep(for: duration)
            return !Task.isCancelled
        } catch {
            return false
        }
    }
}

private struct ProductDetailsContentTransitionModifier: ViewModifier {
    let opacity: Double
    let scale: CGFloat
    let verticalOffset: CGFloat

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .scaleEffect(scale, anchor: .top)
            .offset(y: verticalOffset)
    }
}

#Preview {
    ProductDetailsScreen(scanId: "mock-1234")
}
