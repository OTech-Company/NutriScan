//
//  SwipeToActionButton.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 25/07/2026.
//

import SwiftUI

struct SwipeToActionButton: View {
    var actionTitle: String = "Swipe right to add"
    var action: (@escaping (Bool) -> Void) -> Void

    /// When the parent sets this to `true`, the slider snaps back to idle.
    var shouldReset: Bool = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var dragOffset: CGFloat = 0
    @State private var phase: Phase = .idle
    @State private var trackWidth: CGFloat = 0
    @State private var successPulse = false
    @State private var completionTask: Task<Void, Never>?

    private let thumbWidth: CGFloat = 36
    private let thumbHeight: CGFloat = 36
    private let trackHeight: CGFloat = 44
    private let trackInset: CGFloat = 4 // The horizontal padding inside the track

    private enum Phase: Equatable {
        case idle
        case submitting
        case success
    }

    var body: some View {
        let maxDrag = max(0, trackWidth - thumbWidth - (trackInset * 2))
        let thumbDisplayWidth = phase == .success && !reduceMotion
            ? max(thumbWidth, trackWidth - (trackInset * 2))
            : thumbWidth
        let thumbOffset: CGFloat = {
            switch phase {
            case .success where reduceMotion:
                return maxDrag / 2
            case .success:
                return 0
            default:
                return max(0, min(dragOffset, maxDrag))
            }
        }()

        ZStack(alignment: .leading) {
            // Background Track
            Capsule()
                .fill(
                    phase == .success
                        ? Color.Teal.teal1000.opacity(0.24)
                        : Color.Favorites.swipeBackgroundColor
                )
                .frame(height: trackHeight)

            // Text Instruction (Centered dynamically)
            Text(sliderTitle)
                .font(Font.AppFont.lexendDecaLight12)
                .foregroundColor(Color.Favorites.swipeTextColor)
                .frame(maxWidth: .infinity)
                .padding(.leading, phase == .idle ? 28 : 0)
                .opacity(phase == .success ? 0 : 1)

            // Sliding Thumb / Button
            ZStack {
                Capsule()
                    .foregroundStyle(Color.Teal.teal1000)

                switch phase {
                case .idle:
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .flipsForRightToLeftLayoutDirection(true)
                case .submitting:
                    ProgressView()
                        .controlSize(.small)
                        .tint(.white)
                case .success:
                    Image(systemName: "checkmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .scaleEffect(successPulse ? 1.18 : 1)
                }
            }
            .frame(width: thumbDisplayWidth, height: thumbHeight)
            .offset(x: trackInset + thumbOffset)
        }
        .frame(height: trackHeight)
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        trackWidth = geo.size.width
                    }
                    .onChange(of: geo.size.width) { _, newWidth in
                        trackWidth = newWidth
                    }
            }
        )
        .contentShape(Rectangle())
        .highPriorityGesture(
            DragGesture(minimumDistance: 5)
                .onChanged { value in
                    guard phase == .idle else { return }
                    guard maxDrag > 0 else { return }
                    // Prevent vertical scrolling from triggering horizontal swipe
                    guard abs(value.translation.width) > abs(value.translation.height) else { return }
                    
                    if value.translation.width >= 0 {
                        dragOffset = min(value.translation.width, maxDrag)
                    }
                }
                .onEnded { value in
                    guard phase == .idle else { return }
                    guard maxDrag > 0 else { return }
                    
                    if dragOffset > maxDrag * 0.5 {
                        submit(maxDrag: maxDrag)
                    } else {
                        resetSlider()
                    }
                }
        )
        .onChange(of: shouldReset) { _, newValue in
            if newValue {
                resetSlider()
            }
        }
        .sensoryFeedback(.success, trigger: phase) { _, newPhase in
            newPhase == .success
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(LocalizationKeys.Accessibility.addMealTracking.localized)
        .accessibilityValue(accessibilityValue)
        .accessibilityHint(LocalizationKeys.Accessibility.swipeAddProduct.localized)
        .accessibilityAction {
            submit(maxDrag: maxDrag)
        }
        .onDisappear {
            completionTask?.cancel()
        }
    }

    private func resetSlider() {
        completionTask?.cancel()
        withAnimation(sliderAnimation) {
            dragOffset = 0
            phase = .idle
            successPulse = false
        }
    }

    private func submit(maxDrag: CGFloat) {
        guard phase == .idle, maxDrag > 0 else { return }

        completionTask?.cancel()
        withAnimation(sliderAnimation) {
            dragOffset = maxDrag
            phase = .submitting
        }

        action { success in
            DispatchQueue.main.async {
                if success {
                    showSuccess()
                } else {
                    resetSlider()
                }
            }
        }
    }

    private func showSuccess() {
        withAnimation(sliderAnimation) {
            dragOffset = 0
            phase = .success
        }

        completionTask = Task { @MainActor in
            if !reduceMotion {
                try? await Task.sleep(for: .milliseconds(120))
                guard !Task.isCancelled else { return }
                withAnimation(.spring(response: 0.24, dampingFraction: 0.55)) {
                    successPulse = true
                }

                try? await Task.sleep(for: .milliseconds(180))
                guard !Task.isCancelled else { return }
                withAnimation(.easeOut(duration: 0.16)) {
                    successPulse = false
                }
            }

            try? await Task.sleep(for: .milliseconds(reduceMotion ? 1_200 : 900))
            guard !Task.isCancelled else { return }
            withAnimation(sliderAnimation) {
                dragOffset = 0
                phase = .idle
            }
        }
    }

    private var sliderAnimation: Animation {
        reduceMotion
            ? .easeOut(duration: 0.15)
            : .spring(response: 0.36, dampingFraction: 0.82)
    }

    private var sliderTitle: String {
        switch phase {
        case .idle: return actionTitle
        case .submitting: return LocalizationKeys.Favorites.adding.localized
        case .success: return LocalizationKeys.Favorites.added.localized
        }
    }

    private var accessibilityValue: String {
        switch phase {
        case .idle: return "Ready"
        case .submitting: return "Adding"
        case .success: return "Added"
        }
    }
}

#Preview {
    VStack {
        FavoriteCardView(
            favUIState: FavUIState(id: "1", image: "testImage", title: "Milk Product", calories: 180, condition: .Caution)
        )
    }
    .padding(.horizontal, 80)
}
