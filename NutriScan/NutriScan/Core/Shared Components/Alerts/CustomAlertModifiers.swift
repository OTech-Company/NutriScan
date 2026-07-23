//
//  CustomAlertModifiers.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import SwiftUI

// MARK: - Internal View Wrapper to Handle Mount/Unmount
private struct CustomAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    let type: CustomAlertType
    let title: String
    let description: String
    let primaryButtonTitle: String
    let primaryButtonColor: Color
    let primaryAction: () -> Void
    let secondaryButtonTitle: String?
    let secondaryAction: (() -> Void)?
    
    @State private var isMounted: Bool = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isMounted {
                CustomAlert(
                    type: type,
                    title: title,
                    description: description,
                    primaryButtonTitle: primaryButtonTitle,
                    primaryButtonColor: primaryButtonColor,
                    primaryAction: primaryAction,
                    secondaryButtonTitle: secondaryButtonTitle,
                    secondaryAction: secondaryAction,
                    isPresented: $isPresented,
                    isMounted: $isMounted
                )
                .zIndex(100)
            }
        }
        .onAppear {
            if isPresented {
                isMounted = true
            }
        }
        .onChange(of: isPresented) { oldValue, newValue in
            if newValue {
                isMounted = true
            }
            // CustomAlert handles the transition to false (triggers exit animation, then sets isMounted to false)
        }
    }
}

private struct ActiveAlertModifier: ViewModifier {
    @Binding var activeAlert: ActiveAlert
    
    let config: (ActiveAlert) -> CustomAlertConfig
    let primaryAction: (ActiveAlert) -> Void
    let secondaryAction: ((ActiveAlert) -> Void)?
    
    @State private var mountedAlert: ActiveAlert = .none
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if mountedAlert != .none {
                let resolved = config(mountedAlert)
                
                CustomAlert(
                    type: resolved.type,
                    title: resolved.title,
                    description: resolved.description,
                    primaryButtonTitle: resolved.primaryButtonTitle,
                    primaryButtonColor: resolved.primaryButtonColor,
                    primaryAction: {
                        primaryAction(mountedAlert)
                    },
                    secondaryButtonTitle: resolved.secondaryButtonTitle,
                    secondaryAction: {
                        secondaryAction?(mountedAlert)
                    },
                    activeAlert: $activeAlert,
                    mountedAlert: $mountedAlert
                )
                .zIndex(100)
            }
        }
        .onAppear {
            if activeAlert != .none {
                mountedAlert = activeAlert
            }
        }
        .onChange(of: activeAlert) { oldValue, newValue in
            if newValue != .none {
                mountedAlert = newValue
            }
            // CustomAlert handles the transition to .none (triggers exit animation, then sets mountedAlert to .none)
        }
    }
}

extension View {
    /// Present a CustomAlert over the current view (Single Alert pattern)
    func customAlert(
        isPresented: Binding<Bool>,
        type: CustomAlertType,
        title: String,
        description: String,
        primaryButtonTitle: String = "OK",
        primaryButtonColor: Color = Color.Teal.teal1000,
        primaryAction: @escaping () -> Void,
        secondaryButtonTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil
    ) -> some View {
        self.modifier(CustomAlertModifier(
            isPresented: isPresented,
            type: type,
            title: title,
            description: description,
            primaryButtonTitle: primaryButtonTitle,
            primaryButtonColor: primaryButtonColor,
            primaryAction: primaryAction,
            secondaryButtonTitle: secondaryButtonTitle,
            secondaryAction: secondaryAction
        ))
    }
    
    /// Present a CustomAlert over the current view using enum-based state management
    func customAlert(
        activeAlert: Binding<ActiveAlert>,
        config: @escaping (ActiveAlert) -> CustomAlertConfig,
        primaryAction: @escaping (ActiveAlert) -> Void,
        secondaryAction: ((ActiveAlert) -> Void)? = nil
    ) -> some View {
        self.modifier(ActiveAlertModifier(
            activeAlert: activeAlert,
            config: config,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction
        ))
    }
}
