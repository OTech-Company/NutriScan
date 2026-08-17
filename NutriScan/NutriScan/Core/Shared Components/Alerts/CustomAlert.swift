//
//  CustomAlert.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import SwiftUI

struct CustomAlert: View {
    let config: CustomAlertConfig
    let isPresented: Bool
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
    let onDismissed: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AccessibilityFocusState private var isAlertFocused: Bool

    @State private var showBackdrop = false
    @State private var showCard = false
    @State private var showButtons = false
    @State private var showIcon = false
    @State private var isDismissing = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .opacity(showBackdrop ? 1 : 0)
                .accessibilityHidden(true)

            CustomAlertCard(
                config: config,
                primaryAction: { handleAction(primaryAction) },
                secondaryAction: secondaryAction.map { action in
                    { handleAction(action) }
                },
                actionsDisabled: isDismissing,
                showCard: showCard,
                showIcon: showIcon,
                showButtons: showButtons,
                reduceMotion: reduceMotion
            )
            .accessibilityFocused($isAlertFocused)
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .accessibilityAction(.escape) {
            guard secondaryAction != nil else { return }
            handleAction(secondaryAction)
        }
        .onAppear {
            isAlertFocused = true
            playHaptic()
            runEntranceSequence()
        }
        .onChange(of: isPresented) { _, newValue in
            if newValue {
                if isDismissing {
                    isDismissing = false
                    runEntranceSequence()
                }
            } else {
                dismiss()
            }
        }
    }

    private func playHaptic() {
        UINotificationFeedbackGenerator().notificationOccurred(config.type.hapticType)
    }

    private func runEntranceSequence() {
        if reduceMotion {
            withAnimation(.easeOut(duration: CustomAlertMetrics.backdropEntranceDuration)) {
                showBackdrop = true
                showCard = true
                showButtons = true
                showIcon = true
            }
            return
        }

        withAnimation(.easeOut(duration: CustomAlertMetrics.backdropEntranceDuration)) {
            showBackdrop = true
        }

        withAnimation(
            .spring(
                response: CustomAlertMetrics.cardEntranceResponse,
                dampingFraction: CustomAlertMetrics.cardEntranceDamping
            )
            .delay(CustomAlertMetrics.cardEntranceDelay)
        ) {
            showCard = true
        }

        withAnimation(
            .spring(
                response: CustomAlertMetrics.cardEntranceResponse,
                dampingFraction: CustomAlertMetrics.cardEntranceDamping
            )
            .delay(CustomAlertMetrics.buttonsEntranceDelay)
        ) {
            showButtons = true
        }

        withAnimation(
            .spring(
                response: CustomAlertMetrics.iconEntranceResponse,
                dampingFraction: CustomAlertMetrics.iconEntranceDamping
            )
            .delay(CustomAlertMetrics.iconEntranceDelay)
        ) {
            showIcon = true
        }
    }

    private func handleAction(_ action: (() -> Void)?) {
        guard !isDismissing else { return }
        dismiss()
        action?()
    }

    private func dismiss() {
        guard !isDismissing else { return }
        isDismissing = true

        if reduceMotion {
            withAnimation(.easeIn(duration: CustomAlertMetrics.cardExitDuration)) {
                showBackdrop = false
                showCard = false
                showButtons = false
                showIcon = false
            }
        } else {
            withAnimation(.easeIn(duration: CustomAlertMetrics.cardExitDuration)) {
                showCard = false
                showIcon = false
                showButtons = false
            }

            withAnimation(
                .easeIn(duration: CustomAlertMetrics.backdropExitDuration)
                .delay(CustomAlertMetrics.backdropExitDelay)
            ) {
                showBackdrop = false
            }
        }

        let delay = reduceMotion
            ? CustomAlertMetrics.cardExitDuration
            : CustomAlertMetrics.backdropExitDelay + CustomAlertMetrics.backdropExitDuration

        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.05) {
            onDismissed()
        }
    }
}
