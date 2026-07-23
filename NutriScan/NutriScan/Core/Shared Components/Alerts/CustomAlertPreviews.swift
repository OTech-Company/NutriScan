//
//  CustomAlertPreviews.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import SwiftUI

#Preview("All Alerts Grid - Light Mode") {
    ZStack {
        Color.Teal.teal1600.opacity(0.5)
            .ignoresSafeArea()
            .background(.ultraThinMaterial)
        
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 20) {
                CustomAlertCard(
                    type: .delete,
                    title: "Delete Warning",
                    description: "This is a test alert to verify that notifications are working correctly. No action is required.",
                    primaryButtonTitle: "Delete",
                    primaryButtonColor: Color.Red.red500,
                    primaryAction: {},
                    secondaryButtonTitle: "Cancel",
                    secondaryAction: {},
                    showCard: true,
                    showIcon: true,
                    showButtons: true,
                    reduceMotion: false
                )
                
                CustomAlertCard(
                    type: .success,
                    title: "Success Alert",
                    description: "This is a test alert to verify that notifications are working correctly. No action is required.",
                    primaryButtonTitle: "OK",
                    primaryButtonColor: Color.Teal.teal1000,
                    primaryAction: {},
                    secondaryButtonTitle: "Cancel",
                    secondaryAction: {},
                    showCard: true,
                    showIcon: true,
                    showButtons: true,
                    reduceMotion: false
                )
                
                CustomAlertCard(
                    type: .error,
                    title: "Error Alert",
                    description: "This is a test alert to verify that notifications are working correctly. No action is required.",
                    primaryButtonTitle: "OK",
                    primaryButtonColor: Color.Teal.teal1000,
                    primaryAction: {},
                    secondaryButtonTitle: nil,
                    secondaryAction: nil,
                    showCard: true,
                    showIcon: true,
                    showButtons: true,
                    reduceMotion: false
                )
                
                CustomAlertCard(
                    type: .warning,
                    title: "Warning Alert",
                    description: "This is a test alert to verify that notifications are working correctly. No action is required.",
                    primaryButtonTitle: "OK",
                    primaryButtonColor: Color.Teal.teal1000,
                    primaryAction: {},
                    secondaryButtonTitle: nil,
                    secondaryAction: nil,
                    showCard: true,
                    showIcon: true,
                    showButtons: true,
                    reduceMotion: false
                )
                
                CustomAlertCard(
                    type: .internet,
                    title: "Internet Alert",
                    description: "This is a test alert to verify that notifications are working correctly. No action is required.",
                    primaryButtonTitle: "Retry",
                    primaryButtonColor: Color.Teal.teal1000,
                    primaryAction: {},
                    secondaryButtonTitle: nil,
                    secondaryAction: nil,
                    showCard: true,
                    showIcon: true,
                    showButtons: true,
                    reduceMotion: false
                )
            }
            .padding()
        }
    }
    .preferredColorScheme(.light)
}

#Preview("All Alerts Grid - Dark Mode") {
    ZStack {
        Color.Teal.teal1600.opacity(0.5)
            .ignoresSafeArea()
            .background(.ultraThinMaterial)
        
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 20) {
                CustomAlertCard(
                    type: .delete,
                    title: "Delete Warning",
                    description: "This is a test alert to verify that notifications are working correctly. No action is required.",
                    primaryButtonTitle: "Delete",
                    primaryButtonColor: Color.Red.red500,
                    primaryAction: {},
                    secondaryButtonTitle: "Cancel",
                    secondaryAction: {},
                    showCard: true,
                    showIcon: true,
                    showButtons: true,
                    reduceMotion: false
                )
                
                CustomAlertCard(
                    type: .success,
                    title: "Success Alert",
                    description: "This is a test alert to verify that notifications are working correctly. No action is required.",
                    primaryButtonTitle: "OK",
                    primaryButtonColor: Color.Teal.teal1000,
                    primaryAction: {},
                    secondaryButtonTitle: "Cancel",
                    secondaryAction: {},
                    showCard: true,
                    showIcon: true,
                    showButtons: true,
                    reduceMotion: false
                )
                
                CustomAlertCard(
                    type: .error,
                    title: "Error Alert",
                    description: "This is a test alert to verify that notifications are working correctly. No action is required.",
                    primaryButtonTitle: "OK",
                    primaryButtonColor: Color.Teal.teal1000,
                    primaryAction: {},
                    secondaryButtonTitle: nil,
                    secondaryAction: nil,
                    showCard: true,
                    showIcon: true,
                    showButtons: true,
                    reduceMotion: false
                )
                
                CustomAlertCard(
                    type: .warning,
                    title: "Warning Alert",
                    description: "This is a test alert to verify that notifications are working correctly. No action is required.",
                    primaryButtonTitle: "OK",
                    primaryButtonColor: Color.Teal.teal1000,
                    primaryAction: {},
                    secondaryButtonTitle: nil,
                    secondaryAction: nil,
                    showCard: true,
                    showIcon: true,
                    showButtons: true,
                    reduceMotion: false
                )
                
                CustomAlertCard(
                    type: .internet,
                    title: "Internet Alert",
                    description: "This is a test alert to verify that notifications are working correctly. No action is required.",
                    primaryButtonTitle: "Retry",
                    primaryButtonColor: Color.Teal.teal1000,
                    primaryAction: {},
                    secondaryButtonTitle: nil,
                    secondaryAction: nil,
                    showCard: true,
                    showIcon: true,
                    showButtons: true,
                    reduceMotion: false
                )
            }
            .padding()
        }
    }
    .preferredColorScheme(.dark)
}

#Preview("Interactive Alert Demo") {
    struct InteractivePreview: View {
        @State private var activeAlert: ActiveAlert = .none
        
        var body: some View {
            VStack(spacing: 20) {
                Button("Show Error Alert") {
                    activeAlert = .error
                }
                
                Button("Show Delete Alert") {
                    activeAlert = .delete
                }
                
                Button("Show Success Alert") {
                    activeAlert = .success
                }
            }
            .customAlert(activeAlert: $activeAlert, config: { alert in
                switch alert {
                case .error:
                    return CustomAlertConfig(
                        type: .error,
                        title: "Error",
                        description: "Something went wrong while fetching data. Please try again later."
                    )
                case .delete:
                    return CustomAlertConfig(
                        type: .delete,
                        title: "Delete Item?",
                        description: "Are you sure you want to delete this? This action cannot be undone.",
                        primaryButtonTitle: "Delete",
                        primaryButtonColor: Color.Red.red500,
                        secondaryButtonTitle: "Cancel"
                    )
                case .success:
                    return CustomAlertConfig(
                        type: .success,
                        title: "Operation Successful",
                        description: "The item was successfully processed."
                    )
                default:
                    return CustomAlertConfig(type: .warning, title: "Warning", description: "Unknown alert type")
                }
            }, primaryAction: { _ in
                // Handled
            }, secondaryAction: { _ in
                // Handled
            })
        }
    }
    
    return InteractivePreview()
}
