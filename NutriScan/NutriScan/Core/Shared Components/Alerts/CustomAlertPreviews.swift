//
//  CustomAlertPreviews.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import SwiftUI

private enum PreviewAlert: String, Identifiable {
    case warning
    case delete
    case success
    case error
    case noInternet

    var id: String { rawValue }
}

private struct CustomAlertGallery: View {
    private let types = CustomAlertType.allCases

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 284))], spacing: 20) {
                ForEach(types, id: \.self) { type in
                    previewCard(type: type, hasSecondaryButton: false)
                    previewCard(type: type, hasSecondaryButton: true)
                }
            }
            .padding()
        }
        .background(Color.Teal.teal1600.opacity(0.5).ignoresSafeArea())
    }

    private func previewCard(type: CustomAlertType, hasSecondaryButton: Bool) -> some View {
        CustomAlertCard(
            config: CustomAlertConfig(
                type: type,
                title: title(for: type),
                message: "This message verifies the two-line alert treatment and its semantic icon.",
                primaryButton: primaryButton(for: type),
                secondaryButton: hasSecondaryButton ? CustomAlertButton("Cancel", role: .cancel) : nil
            ),
            primaryAction: {},
            secondaryAction: hasSecondaryButton ? {} : nil,
            actionsDisabled: false,
            showCard: true,
            showIcon: true,
            showButtons: true,
            reduceMotion: false
        )
    }

    private func title(for type: CustomAlertType) -> String {
        switch type {
        case .warning: return "Warning Alert"
        case .delete: return "Delete Warning"
        case .success: return "Success Alert"
        case .error: return "Error Alert"
        case .noInternet: return "No Internet Connection"
        }
    }

    private func primaryButton(for type: CustomAlertType) -> CustomAlertButton {
        switch type {
        case .delete:
            return CustomAlertButton("Delete", role: .destructive)
        case .noInternet:
            return CustomAlertButton("Retry")
        case .warning, .success, .error:
            return CustomAlertButton("OK")
        }
    }
}

private struct InteractiveAlertPreview: View {
    @State private var alert: PreviewAlert?

    var body: some View {
        VStack(spacing: 20) {
            Button("Show Warning") { alert = .warning }
            Button("Show Delete") { alert = .delete }
            Button("Show Success") { alert = .success }
            Button("Show Error") { alert = .error }
            Button("Show No Internet") { alert = .noInternet }
        }
        .customAlert(
            item: $alert,
            config: config,
            primaryAction: { _ in },
            secondaryAction: { _ in }
        )
    }

    private func config(for alert: PreviewAlert) -> CustomAlertConfig {
        switch alert {
        case .warning:
            return CustomAlertConfig(type: .warning, title: "Warning", message: "Review this information before continuing.")
        case .delete:
            return CustomAlertConfig(
                type: .delete,
                title: "Delete Item?",
                message: "This action cannot be undone.",
                primaryButton: CustomAlertButton("Delete", role: .destructive),
                secondaryButton: CustomAlertButton("Cancel", role: .cancel)
            )
        case .success:
            return CustomAlertConfig(type: .success, title: "Success", message: "The operation completed successfully.")
        case .error:
            return CustomAlertConfig(type: .error, title: "Error", message: "Something went wrong. Please try again.")
        case .noInternet:
            return CustomAlertConfig(
                type: .noInternet,
                title: "No Internet Connection",
                message: "Check your connection and try again.",
                primaryButton: CustomAlertButton("Retry")
            )
        }
    }
}

#Preview("All Alerts · Light") {
    CustomAlertGallery()
        .preferredColorScheme(.light)
}

#Preview("All Alerts · Dark") {
    CustomAlertGallery()
        .preferredColorScheme(.dark)
}

#Preview("Accessibility Type") {
    CustomAlertGallery()
        .environment(\.dynamicTypeSize, .accessibility3)
}

#Preview("Right to Left") {
    CustomAlertGallery()
        .environment(\.layoutDirection, .rightToLeft)
}

#Preview("Interactive") {
    InteractiveAlertPreview()
}
