//
//  CustomAlert.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import SwiftUI

struct CustomAlert: View {
    let type: CustomAlertType
    let title: String
    let description: String
    let primaryButtonTitle: String
    let primaryButtonColor: Color
    let primaryAction: () -> Void
    let secondaryButtonTitle: String?
    let secondaryAction: (() -> Void)?
    
    var isPresented: Binding<Bool>? = nil
    var activeAlert: Binding<ActiveAlert>? = nil
    var isMounted: Binding<Bool>? = nil
    var mountedAlert: Binding<ActiveAlert>? = nil
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @AccessibilityFocusState private var isAlertFocused: Bool
    
    @State private var showBackdrop = false
    @State private var showCard = false
    @State private var showButtons = false
    @State private var showIcon = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .opacity(showBackdrop ? 1 : 0)
                .zIndex(0)
                .onTapGesture {
                    dismissAlert()
                }
            
            CustomAlertCard(
                type: type,
                title: title,
                description: description,
                primaryButtonTitle: primaryButtonTitle,
                primaryButtonColor: primaryButtonColor,
                primaryAction: handlePrimaryAction,
                secondaryButtonTitle: secondaryButtonTitle,
                secondaryAction: handleSecondaryAction,
                showCard: showCard,
                showIcon: showIcon,
                showButtons: showButtons,
                reduceMotion: reduceMotion
            )
            .zIndex(1)
            .accessibilityFocused($isAlertFocused)
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .onAppear {
            isAlertFocused = true
            playHaptic()
            runEntranceSequence()
        }
    }
    
    private func playHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type.hapticType)
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
            .spring(response: CustomAlertMetrics.cardEntranceResponse, dampingFraction: CustomAlertMetrics.cardEntranceDamping)
            .delay(CustomAlertMetrics.cardEntranceDelay)
        ) {
            showCard = true
        }
        
        withAnimation(
            .spring(response: CustomAlertMetrics.cardEntranceResponse, dampingFraction: CustomAlertMetrics.cardEntranceDamping)
            .delay(CustomAlertMetrics.buttonsEntranceDelay)
        ) {
            showButtons = true
        }
        
        withAnimation(
            .spring(response: CustomAlertMetrics.iconEntranceResponse, dampingFraction: CustomAlertMetrics.iconEntranceDamping)
            .delay(CustomAlertMetrics.iconEntranceDelay)
        ) {
            showIcon = true
        }
    }
    
    private func runExitSequence() {
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
            
            withAnimation(.easeIn(duration: CustomAlertMetrics.backdropExitDuration).delay(CustomAlertMetrics.backdropExitDelay)) {
                showBackdrop = false
            }
        }
        
        let maxDelay = reduceMotion ? CustomAlertMetrics.cardExitDuration : (CustomAlertMetrics.backdropExitDelay + CustomAlertMetrics.backdropExitDuration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + maxDelay + 0.05) {
            isMounted?.wrappedValue = false
            mountedAlert?.wrappedValue = .none
        }
    }
    
    private func dismissAlert() {
        if isPresented?.wrappedValue == true {
            isPresented?.wrappedValue = false
        }
        if activeAlert?.wrappedValue != Optional.none {
            activeAlert?.wrappedValue = .none
        }
        runExitSequence()
    }
    
    private func handlePrimaryAction() {
        dismissAlert()
        primaryAction()
    }
    
    private func handleSecondaryAction() {
        dismissAlert()
        secondaryAction?()
    }
}
